use clap::{CommandFactory, Parser};
use dotfiles::{
    full_path, generate_completions, iso8601_filename, kill_wrapped_process,
    monitor::Monitor,
    nixinfo::NixInfo,
    wallpaper::{self, get_wallpaper_info},
    wallust, ShellCompletion,
};
use execute::Execute;
use hyprland::dispatch::{Dispatch, DispatchType};
use std::{collections::HashSet, path::PathBuf};
use sysinfo::Signal;

#[derive(Parser, Debug)]
#[command(
    name = "hypr-wallpaper",
    about = "Changes the wallpaper and updates the colorcheme"
)]
pub struct HyprWallpaperArgs {
    #[arg(long, action, help = "reload current wallpaper")]
    pub reload: bool,

    // optional image to use, uses a random one otherwise
    pub image_or_dir: Option<PathBuf>,

    #[arg(
        long,
        action,
        aliases = ["rofi"],
        help = "show wallpaper selector with pqiv",
        exclusive = true
    )]
    pub pqiv: bool,

    #[arg(
        long,
        value_enum,
        help = "type of shell completion to generate",
        hide = true,
        exclusive = true
    )]
    pub generate: Option<ShellCompletion>,
}

fn show_pqiv() {
    const TARGET_PERCENT: f64 = 0.3;

    let mon = Monitor::focused();

    let mut width = f64::from(mon.width) * TARGET_PERCENT;
    let mut height = f64::from(mon.height) * TARGET_PERCENT;

    // handle vertical monitor
    if height > width {
        std::mem::swap(&mut width, &mut height);
    }

    let float_rule = format!("[float;size {} {};center]", width.floor(), height.floor());

    Dispatch::call(DispatchType::Exec(&format!(
        "{float_rule} pqiv --shuffle '{}'",
        &wallpaper::dir().to_str().expect("invalid wallpaper dir")
    )))
    .expect("failed to execute kitty");
}

fn main() {
    let args = HyprWallpaperArgs::parse();

    // print shell completions
    if let Some(shell) = args.generate {
        return generate_completions("hypr-monitors", &mut HyprWallpaperArgs::command(), &shell);
    }

    // show pqiv for selecting wallpaper, via the "w" keybind
    if args.pqiv {
        show_pqiv();
        return;
    }

    let random_wallpaper = match args.image_or_dir {
        Some(image_or_dir) => {
            if image_or_dir.is_dir() {
                wallpaper::random_from_dir(&image_or_dir)
            } else {
                std::fs::canonicalize(&image_or_dir)
                    .unwrap_or_else(|_| panic!("invalid wallpaper: {image_or_dir:?}"))
                    .to_str()
                    .unwrap_or_else(|| panic!("could not conver {image_or_dir:?} to str"))
                    .to_string()
            }
        }
        None => {
            if full_path("~/.cache/wallust/nix.json").exists() {
                wallpaper::random()
            } else {
                NixInfo::before().fallback
            }
        }
    };

    let wallpaper = if args.reload {
        wallpaper::current().unwrap_or(random_wallpaper)
    } else {
        random_wallpaper
    };

    // write current wallpaper to $XDG_RUNTIME_DIR/current_wallpaper
    std::fs::write(
        dirs::runtime_dir()
            .expect("could not get $XDG_RUNTIME_DIR")
            .join("current_wallpaper"),
        &wallpaper,
    )
    .expect("failed to write $XDG_RUNTIME_DIR/current_wallpaper");

    let wallpaper_info = get_wallpaper_info(&wallpaper);

    // use colorscheme set from nix if available
    if let Some(cs) = NixInfo::before().colorscheme {
        wallust::apply_theme(&cs);
    } else {
        wallust::from_wallpaper(&wallpaper_info, &wallpaper);
    }

    // do wallust earlier to create the necessary templates
    wallust::apply_colors();

    if args.reload {
        kill_wrapped_process("waybar", Signal::User2);
    }
    execute::command!("swww-crop")
        .arg(&wallpaper)
        .execute()
        .ok();

    if !args.reload {
        // write the image as a timestamp to a wallpaper_history directory
        let wallpaper_history = full_path("~/Pictures/wallpaper_history");
        std::fs::create_dir_all(&wallpaper_history)
            .expect("failed to create wallpaper_history directory");

        let target = wallpaper_history.join(iso8601_filename());

        std::os::unix::fs::symlink(wallpaper, target)
            .expect("unable to create wallpaper history symlink");

        // remove broken and duplicate symlinks
        let mut uniq_history = HashSet::new();
        let mut history: Vec<_> = std::fs::read_dir(&wallpaper_history)
            .expect("failed to read wallpaper_history directory")
            .filter_map(|entry| entry.ok().map(|e| e.path()))
            .skip(1) // ignore current wallpaper being set
            .collect();
        history.sort_by(|a, b| b.file_name().cmp(&a.file_name()));

        for path in history {
            if let Ok(resolved) = std::fs::read_link(&path) {
                if uniq_history.contains(&resolved) {
                    std::fs::remove_file(path).expect("failed to remove duplicate symlink");
                } else {
                    uniq_history.insert(resolved.clone());
                }
            } else {
                std::fs::remove_file(path).expect("failed to remove broken symlink");
            }
        }
    }
}