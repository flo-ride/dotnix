{ pkgs, prev, flake, lib, ... }:

let
  inherit (flake) inputs;
  inherit (inputs) self;


  unstable = import inputs.nixos-unstable {
    system = pkgs.system;
    config.allowUnfree = true;
  };
in
{
  home.packages = with pkgs; [
    # Tools
    pavucontrol
    networkmanagerapplet
    blueberry
    wdisplays
    pulsemixer
    brightnessctl

    # Dev
    libreoffice

    # Productivity
    flameshot
    xfce.thunar
    (pkgs.discord.override {
      #withOpenASAR = true;
      withVencord = true;
    })
    termius

    # Fun
    spotify

    # SSH
    xpipe

    # Password
    bitwarden-desktop
  ];
}
