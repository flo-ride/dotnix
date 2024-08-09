{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader = {
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot/efi";

    # systemd-boot.enable = true;

    grub.enable = true;
    grub.efiSupport = true;
    grub.device = "nodev";
    grub.useOSProber = true;

  };

  networking = {
    hostName = "legion";
    networkmanager.enable = true;
    extraHosts = ''
      127.0.0.1 floride.local
    '';
    # firewall.checkReversePath = false;
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    firefox
    alacritty
    fish
  ];

  virtualisation.docker.enable = true;

  programs.steam.enable = true;

  system.stateVersion = "24.05";
}
