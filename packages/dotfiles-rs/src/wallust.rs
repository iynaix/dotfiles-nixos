use crate::{
    colors::{NixColors, Rgb},
    full_path, json, kill_wrapped_process,
    wallpaper::WallInfo,
    CommandUtf8,
};
use core::panic;
use execute::Execute;
use hyprland::keyword::Keyword;
use image::ImageReader;
use itertools::Itertools;
use std::collections::HashMap;

pub const CUSTOM_THEMES: [&str; 6] = [
    "catppuccin-frappe",
    "catppuccin-macchiato",
    "catppuccin-mocha",
    "decay-dark",
    "night-owl",
    "tokyo-night",
];

pub fn apply_theme(theme: &str) {
    if CUSTOM_THEMES.contains(&theme) {
        let colorscheme_file = full_path(format!("~/.config/wallust/themes/{theme}.json"));
        execute::command_args!(
            "wallust",
            "cs",
            colorscheme_file
                .to_str()
                .unwrap_or_else(|| panic!("invalid colorscheme file: {colorscheme_file:?}")),
        )
        .execute()
        .unwrap_or_else(|_| panic!("failed to apply colorscheme {theme}"));
    } else {
        execute::command_args!("wallust", "theme", &theme)
            .execute()
            .unwrap_or_else(|_| panic!("failed to apply wallust theme {theme}"));
    }
}

fn refresh_zathura() {
    if let Some(zathura_pid_raw) = execute::command_args!(
        "dbus-send",
        "--print-reply",
        "--dest=org.freedesktop.DBus",
        "/org/freedesktop/DBus",
        "org.freedesktop.DBus.ListNames",
    )
    .execute_stdout_lines()
    .iter()
    .find(|line| line.contains("org.pwmt.zathura"))
    {
        if let Some(zathura_pid) = zathura_pid_raw.split('"').max_by_key(|s| s.len()) {
            // send message to zathura via dbus
            execute::command_args!(
                "dbus-send",
                "--type=method_call",
                &format!("--dest={zathura_pid}"),
                "/org/pwmt/zathura",
                "org.pwmt.zathura.ExecuteCommand",
                "string:source",
            )
            .execute()
            .ok();
        }
    }
}

fn apply_hyprland_colors(accents: &[Rgb], colors: &HashMap<String, Rgb>) {
    let color = |idx: usize| {
        colors
            .get(&format!("color{idx}"))
            .unwrap_or_else(|| panic!("key color{idx} not found"))
    };
    let accent_or_color = |accent_idx: usize, color_idx: usize| {
        accents
            .get(accent_idx)
            .unwrap_or_else(|| color(color_idx))
            .to_rgb_str()
    };

    // update borders
    Keyword::set(
        "general:col.active_border",
        format!("{} {} 45deg", accent_or_color(0, 4), &color(0).to_rgb_str(),),
    )
    .expect("failed to set hyprland active border color");

    Keyword::set("general:col.inactive_border", color(0).to_rgb_str())
        .expect("failed to set hyprland inactive border color");

    // pink border for monocle windows
    Keyword::set(
        "windowrulev2",
        format!("bordercolor {},fullscreen:1", accent_or_color(1, 5),),
    )
    .expect("failed to set hyprland fakefullscreen border color");

    // teal border for floating windows
    Keyword::set(
        "windowrulev2",
        format!("bordercolor {},floating:1", accent_or_color(2, 6)),
    )
    .expect("failed to set hyprland floating border color");

    // yellow border for sticky (must be floating) windows
    Keyword::set(
        "windowrulev2",
        format!("bordercolor {},pinned:1", color(3).to_rgb_str()),
    )
    .expect("failed to set hyprland sticky border color");
}

/// sort accents by their color usage within the wallpaper
fn accents_by_usage(wallpaper: &str, accents: &[Rgb]) -> HashMap<Rgb, usize> {
    // open wallpaper and read colors
    let img = ImageReader::open(wallpaper)
        .expect("could not open image")
        .decode()
        .expect("could not decode image")
        .to_rgb8();

    // initialize with each accent as a color might not be used
    let mut color_counts: HashMap<_, _> = accents.iter().map(|a| (a.clone(), 0)).collect();

    // sample middle of every 9x9 pixel block
    for x in (4..img.width()).step_by(5) {
        for y in (4..img.height()).step_by(5) {
            let px = img.get_pixel(x, y);

            let closest_color = accents
                .iter()
                .enumerate()
                .min_by_key(|(_, color)| {
                    color.distance_sq(&Rgb {
                        r: px[0],
                        g: px[1],
                        b: px[2],
                    })
                })
                .expect("could not find closest color");

            // store the closest color
            *color_counts.entry(closest_color.1.clone()).or_default() += 1;
        }
    }

    color_counts
        .iter()
        .sorted_by(|a, b| b.1.cmp(a.1))
        .enumerate()
        .map(|(n, (color, _count))| (color.clone(), n))
        .collect()
}

/// sort accents by how contrasting they are to the background and foreground
fn accents_by_contrast(accents: &[Rgb]) -> HashMap<Rgb, usize> {
    let nixcolors = NixColors::new().expect("unable to parse nix.json");

    let (x1, y1, z1) = nixcolors.special.background.to_i64();
    let (x2, y2, z2) = nixcolors.special.foreground.to_i64();

    accents
        .iter()
        .sorted_by_key(|c| {
            let (x3, y3, z3) = c.to_i64();

            // compute area of the triangle formed by the colors
            let t1 = (y2 - y1) * (z3 - z1) - (z2 - z1) * (y3 - y1);
            let t2 = (z2 - z1) * (x3 - x1) - (x2 - x1) * (z3 - z1);
            let t3 = (x2 - x1) * (y3 - y1) - (y2 - y1) * (x3 - x1);

            // should be square root then halved, but makes no difference if just comparing
            // negative for sorting in descending order
            -(t1 * t1 + t2 * t2 + t3 * t3)
        })
        .enumerate()
        .map(|(n, color)| (color.clone(), n))
        .collect()
}

/// applies the wallust colors to various applications
pub fn apply_colors() {
    if let Ok(nixcolors) = NixColors::new() {
        // ignore black and white
        let colors = nixcolors
            .filter_colors(&["color0", "color7", "color8", "color15"])
            .into_values()
            .collect_vec();

        let by_usage = accents_by_usage(&nixcolors.wallpaper, &colors);

        let by_contrast = accents_by_contrast(&colors);

        #[allow(clippy::cast_precision_loss)]
        let accents = by_contrast
            .iter()
            // calculate score for each color
            .map(|(color, i)| {
                // how much of the score should be based on contrast
                let contrast_pct = 0.78;

                #[allow(clippy::cast_precision_loss)]
                (
                    (*i as f64).mul_add(
                        contrast_pct,
                        (by_usage[color] as f64) * (1.0 - contrast_pct),
                    ),
                    color.clone(),
                )
            })
            .sorted_by(|a, b| a.0.partial_cmp(&b.0).expect("could not compare floats"))
            .map(|(_, color)| color)
            .collect_vec();

        apply_hyprland_colors(&accents, &nixcolors.colors);

        // set the waybar accent color to have more contrast
        set_waybar_accent(&nixcolors, &accents[0]);

        set_gtk_and_icon_theme(&nixcolors, &accents[0]);
    } else {
        #[derive(serde::Deserialize)]
        struct Colorscheme {
            colors: HashMap<String, Rgb>,
        }

        let cs_path = full_path("~/.config/wallust/themes/catppuccin-mocha.json");
        let cs: Colorscheme = json::load(&cs_path).unwrap_or_else(|_| {
            panic!("unable to read colorscheme at {:?}", &cs_path);
        });

        apply_hyprland_colors(&[], &cs.colors);
    };

    refresh_zathura();

    // refresh cava
    kill_wrapped_process("cava", "SIGUSR2");

    // refresh wfetch
    kill_wrapped_process("wfetch", "SIGUSR2");

    // refresh waybar, process is killed and restarted as sometimes reloading kills the process :(
    execute::command!("launch-waybar")
        .spawn()
        .expect("failed to launch waybar");
}

/// runs wallust with options from wallpapers.csv
pub fn from_wallpaper(wallpaper_info: &Option<WallInfo>, wallpaper: &str) {
    let mut wallust = execute::command_args!("wallust", "run", "--no-cache", "--check-contrast");

    // normalize the options for wallust
    if let Some(WallInfo { wallust: opts, .. }) = wallpaper_info {
        // split opts into flags
        if !opts.is_empty() {
            let opts: Vec<&str> = opts.split(' ').map(str::trim).collect();
            wallust.args(opts);
        }
    }

    wallust
        .arg(wallpaper)
        .execute()
        .expect("wallust: failed to set colors from wallpaper");
}

pub fn set_gtk_and_icon_theme(nixcolors: &NixColors, accent: &Rgb) {
    let variant = nixcolors
        .theme_accents
        .iter()
        .min_by_key(|(_, theme_color)| theme_color.distance_sq(accent))
        .expect("no closest theme color found")
        .0;

    // requires the single quotes to be GVariant compatible for dconf
    let gvariant = |v: &str| format!("'{v}'");

    let gtk_theme = format!("catppuccin-mocha-{variant}-compact");
    execute::command_args!("dconf", "write", "/org/gnome/desktop/interface/gtk-theme")
        .arg(gvariant(&gtk_theme))
        .execute()
        .expect("failed to apply gtk theme");

    // requires the single quotes to be GVariant compatible for dconf
    let icon_theme = format!("Tela-{variant}-dark");
    execute::command_args!("dconf", "write", "/org/gnome/desktop/interface/icon-theme")
        .arg(gvariant(&icon_theme))
        .execute()
        .expect("failed to apply icon theme");

    // update the icon theme for dunst
    let dunstrc_path = full_path("~/.cache/wallust/dunstrc");

    if let Ok(dunstrc) = std::fs::read_to_string(&dunstrc_path) {
        let dunstrc = dunstrc
            .lines()
            .map(|line| {
                if line.starts_with("icon_theme") {
                    format!("icon_theme=\"{icon_theme}\"")
                } else {
                    line.to_string()
                }
            })
            .collect::<Vec<String>>()
            .join("\n");

        std::fs::write(dunstrc_path, dunstrc).ok();
    }
}

pub fn set_waybar_accent(nixcolors: &NixColors, accent: &Rgb) {
    // get inverse color for inversed module classes
    let inverse = accent.inverse();

    let css_path = full_path("~/.config/waybar/style.css");
    let mut css = std::fs::read_to_string(&css_path).expect("could not read waybar css");

    // replace old foreground color with new inverse color
    css = css.replace(
        &nixcolors.special.foreground.to_hex_str(),
        &accent.to_hex_str(),
    );

    // replace inverse classes
    css = css
        .lines()
        .map(|line| {
            if line.ends_with("/* inverse */") {
                format!("color: {}; /* inverse */", inverse.to_hex_str())
            } else {
                line.to_string()
            }
        })
        .collect::<Vec<String>>()
        .join("\n");

    std::fs::write(css_path, css).expect("could not write waybar css");
}
