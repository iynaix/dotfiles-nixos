{
  pkgs,
  user,
  config,
  lib,
  ...
}: {
  options.iynaix.wezterm = {
    enable = lib.mkEnableOption "wezterm" // {default = true;};
  };

  config = lib.mkIf config.iynaix.wezterm.enable {
    iynaix.terminal = {
      exec = lib.mkIf (config.iynaix.terminal.package == pkgs.wezterm) "${lib.getExe pkgs.wezterm} start";
      fakeGnomeTerminal = lib.mkIf (config.iynaix.terminal.package == pkgs.wezterm) (pkgs.writeShellScriptBin "gnome-terminal" ''
        shift

        TITLE="$(basename "$1")"
        if [ -n "$TITLE" ]; then
          ${config.iynaix.terminal.exec} --class "$TITLE" "$@"
        else
          ${config.iynaix.terminal.exec} "$@"
        fi
      '');
    };

    home-manager.users.${user} = {
      home.packages = with pkgs; [
        lsix
        (pkgs.callPackage ../../pkgs/vv.nix {})
      ];

      home.file.".config/wal/templates/colors.toml".text = ''
        [colors]
        ansi = [
          '{color0}',
          '{color1}',
          '{color2}',
          '{color3}',
          '{color4}',
          '{color5}',
          '{color6}',
          '{color7}',
        ]
        background = '{background}'
        brights = [
          '{color8}',
          '{color9}',
          '{color10}',
          '{color11}',
          '{color12}',
          '{color13}',
          '{color14}',
          '{color15}',
        ]
        cursor_bg = '{background}'
        cursor_border = '{cursor}'
        cursor_fg = '{cursor}'
        foreground = '{foreground}'
        selection_bg = '{foreground}'
        selection_fg = '{background}'

        [colors.indexed]

        [metadata]
        name = 'Pywal'
        origin_url = 'https://github.com/dylanaraps/pywal'
      '';

      programs = {
        wezterm = {
          enable = true;
          extraConfig = with config.iynaix.terminal; ''
            local wezterm = require "wezterm"

            function make_mouse_binding(dir, streak, button, mods, action)
              return {
                event = { [dir] = { streak = streak, button = button } },
                mods = mods,
                action = action,
              }
            end

            return {
              font = wezterm.font('${font}', {
                weight = "Regular",
              }),
              harfbuzz_features = { 'zero=1' },
              font_size = ${toString (size - 1)},
              window_background_opacity = ${toString opacity},
              enable_scroll_bar = false,
              enable_tab_bar = false,
              enable_wayland = false,
              scrollback_lines = 10000,
              color_scheme_dirs = { "/home/${user}/.cache/wal" },
              color_scheme = "Pywal",
              window_padding = {
                left = ${toString padding},
                right = ${toString padding},
                top = ${toString padding},
                bottom = ${toString padding},
              },
              check_for_updates = false,
              default_cursor_style = "SteadyBar",
              -- copy on select, see:
              -- https://github.com/wez/wezterm/issues/2588#issuecomment-1268054635
              mouse_bindings = {
                make_mouse_binding('Up', 1, 'Left', 'NONE', wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor 'ClipboardAndPrimarySelection'),
                make_mouse_binding('Up', 1, 'Left', 'SHIFT', wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor 'ClipboardAndPrimarySelection'),
                make_mouse_binding('Up', 1, 'Left', 'ALT', wezterm.action.CompleteSelection 'ClipboardAndPrimarySelection'),
                make_mouse_binding('Up', 1, 'Left', 'SHIFT|ALT', wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor 'ClipboardAndPrimarySelection'),
                make_mouse_binding('Up', 2, 'Left', 'NONE', wezterm.action.CompleteSelection 'ClipboardAndPrimarySelection'),
                make_mouse_binding('Up', 3, 'Left', 'NONE', wezterm.action.CompleteSelection 'ClipboardAndPrimarySelection'),
              },
            }
          '';
        };
      };
    };

    nixpkgs.overlays = [
      (self: super: {
        lsix = super.lsix.overrideAttrs (oldAttrs: {
          # add default font to silence null font errors
          postFixup = ''
            substituteInPlace $out/bin/lsix \
              --replace '#fontfamily=Mincho' 'fontfamily="JetBrains-Mono-Regular-Nerd-Font-Complete"'
            ${oldAttrs.postFixup}
          '';
        });
      })
    ];
  };
}