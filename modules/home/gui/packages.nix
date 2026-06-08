{
  pkgs,
  flake,
  ...
}: let
  unstablePkgs = flake.inputs.nixos-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
  home.packages = with pkgs; [
    # Tools
    pavucontrol
    networkmanagerapplet
    blueman
    wdisplays
    pulsemixer
    brightnessctl

    # Dev
    libreoffice

    # Productivity
    flameshot
    thunar
    (discord-ptb.override {
      withOpenASAR = true;
      withVencord = true;
    })
    termius

    # Fun
    spotify

    # SSH
    xpipe

    # Password
    bitwarden-desktop

    # Moonlight
    moonlight-qt

    feh

    # Rust Desk
    rustdesk
  ];
}
