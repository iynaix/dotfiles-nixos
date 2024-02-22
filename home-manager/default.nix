{
  user,
  pkgs,
  lib,
  config,
  isNixOS,
  ...
}:
{
  imports = [
    ./hyprland
    ./programs
    ./shell
  ];

  # setup fonts for other distros, run "fc-cache -f" to refresh fonts
  fonts.fontconfig.enable = true;

  home = {
    username = user;
    homeDirectory = "/home/${user}";
    # do not change this value
    stateVersion = "23.05";

    sessionVariables = {
      __IS_NIXOS = if isNixOS then "1" else "0";
      NIXPKGS_ALLOW_UNFREE = "1";
    };

    packages =
      with pkgs;
      [
        curl
        gzip
        killall
        rar # includes unrar
        ripgrep
        libreoffice
        trash-cli
        xdg-utils
        # misc utilities for dotfiles written in rust
        custom.dotfiles-utils
      ]
      ++ (lib.optional config.custom.helix.enable helix)
      # home-manager executable only on non-nixos
      ++ (lib.optional (!isNixOS) home-manager)
      # handle fonts
      ++ (lib.optionals (!isNixOS) config.custom.fonts.packages);
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # stop bothering me
  xdg = {
    enable = true;
    userDirs.enable = true;
    mimeApps.enable = true;
  };

  custom.persist = {
    home.directories = [
      "Desktop"
      "Documents"
      "Pictures"
    ];
  };
}
