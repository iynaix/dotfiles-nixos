{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.iynaix.terminal;
in {
  options.iynaix.terminal = {
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.kitty;
      description = "Terminal package to use.";
    };

    exec = lib.mkOption {
      type = lib.types.str;
      default =
        if cfg.package == pkgs.kitty
        then "${cfg.package}/bin/kitty"
        else "${lib.getExe cfg.package}";
      description = "Terminal command to execute other programs.";
    };

    font = lib.mkOption {
      type = lib.types.str;
      default = config.iynaix.fonts.monospace;
      description = "Font for the terminal.";
    };

    size = lib.mkOption {
      type = lib.types.int;
      default = 11;
      description = "Font size for the terminal.";
    };

    padding = lib.mkOption {
      type = lib.types.int;
      default = 12;
      description = "Padding for the terminal.";
    };

    opacity = lib.mkOption {
      type = lib.types.float;
      default = 0.7;
      description = "Opacity for the terminal.";
    };

    # create a fake gnome-terminal shell script so xdg terminal applications open in the correct terminal
    # https://unix.stackexchange.com/a/642886
    fakeGnomeTerminal = lib.mkOption {
      type = lib.types.package;
      default = (
        pkgs.writeShellApplication {
          name = "gnome-terminal";
          text = ''
            shift

            TITLE="$(basename "$1")"
            if [ -n "$TITLE" ]; then
              ${cfg.exec} -T "$TITLE" "$@"
            else
              ${cfg.exec} "$@"
            fi
          '';
        }
      );
      description = "Fake gnome-terminal shell script so gnome opens terminal applications in the correct terminal.";
    };
  };

  options.iynaix.shell = {
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.zsh;
      description = "Default shell to use.";
    };
    initExtra = lib.mkOption {
      default = "";
      type = lib.types.lines;
      description = "Extra shell agnostic commands that should be run when initializing an interactive shell.";
    };
    profileExtra = lib.mkOption {
      default = "";
      type = lib.types.lines;
      description = "Extra shell agnostic commands that should be run when initializing a login shell.";
    };
  };
}
