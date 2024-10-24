{
  config,
  lib,
  pkgs,
  user,
  ...
}:
{
  custom = {
    # hardware
    hdds.enable = true;
    nvidia.enable = true;
    qmk.enable = false;
    zfs.encryption = false;

    # software
    bittorrent.enable = false;
    distrobox.enable = false;
    # plasma.enable = true;
    syncoid.enable = false;
    vercel.enable = false;
    virtualization.enable = true;
  };

  networking.hostId = "84053ac6"; # required for zfs

  services.displayManager.autoLogin.user = user;

  networking = {
    interfaces.enp5s0.wakeOnLan.enable = true;
    # open ports for devices on the local network
    firewall.extraCommands = ''
      iptables -A nixos-fw -p tcp --source 192.168.1.0/24 -j nixos-fw-accept
    '';
  };

  # fix no login prompts in ttys, virtual tty are being redirected to mobo video output
  # https://unix.stackexchange.com/a/253401
  boot.blacklistedKernelModules = [ "amdgpu" ];

  # enable flirc usb ir receiver
  hardware.flirc.enable = false;
  environment.systemPackages = lib.mkIf config.hardware.flirc.enable [ pkgs.flirc ];

  # fix intel i225-v ethernet dying due to power management
  # https://reddit.com/r/buildapc/comments/xypn1m/network_card_intel_ethernet_controller_i225v_igc/
  # boot.kernelParams = ["pcie_port_pm=off" "pcie_aspm.policy=performance"];
}