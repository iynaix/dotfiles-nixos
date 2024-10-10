{
  config,
  isNixOS,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.rio;
  inherit (config.custom) terminal;
in
{
  options.custom = with lib; {
    rio.enable = mkEnableOption "rio" // {
      default = isNixOS;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.rio = {
      enable = true;
      settings = {
        theme = "catppuccin-mocha";
        fonts = {
          family = terminal.font;
          inherit (terminal) size;
        };
        window = {
          opacity = builtins.fromJSON terminal.opacity;
          decorations = "Disabled";
        };
        shell = {
          program = "${pkgs.fish}";
          args = [ ];
        };
        editor = {
          program = "hx";
          args = [ ];
        };
        padding-x = terminal.padding;
        confirm-before-quit = true;
      };
    };

    home.file.".config/rio/themes/catppuccin-mocha.toml" = {
      force = true;
      text = ''
        [colors]

        # Normal
        foreground       = '#cdd6f4'
        background       = '#1e1e2e'
        black            = '#45475a'
        blue             = '#89b4fa'
        cursor           = '#f5e0dc'
        cyan             = '#94e2d5'
        green            = '#a6e3a1'
        magenta          = '#f5c2e7'
        red              = '#f38ba8'
        white            = '#bac2de'
        yellow           = '#f9e2af'

        # UI colors
        tabs             = '#1e1e2e'
        tabs-active      = '#b4befe'
        selection-foreground = '#1e1e2e'
        selection-background = '#f5e0dc'

        # Dim colors
        dim-black        = '#45475a'
        dim-blue         = '#89b4fa'
        dim-cyan         = '#94e2d5'
        dim-foreground   = '#cdd6f4'
        dim-green        = '#a6e3a1'
        dim-magenta      = '#f5c2e7'
        dim-red          = '#f38ba8'
        dim-white        = '#bac2de'
        dim-yellow       = '#f9e2af'

        # Light colors
        light-black      = '#585b70'
        light-blue       = '#89b4fa'
        light-cyan       = '#94e2d5'
        light-foreground = '#cdd6f4'
        light-green      = '#a6e3a1'
        light-magenta    = '#f5c2e7'
        light-red        = '#f38ba8'
        light-white      = '#a6adc8'
        light-yellow     = '#f9e2af'            
      '';
    };

    home.shellAliases = {
      # change color on ssh
      # ssh = "kitten ssh --kitten=color_scheme=Dracula";
    };
  };
}
