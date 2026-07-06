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
    pulsemixer
    brightnessctl

    # Dev
    libreoffice

    # Productivity
    thunar
    (discord-ptb.override {
      withOpenASAR = true;
      withVencord = true;
    })

    # Fun
    spotify

    # SSH
    xpipe

    # Password
    bitwarden-desktop

    # Moonlight
    moonlight-qt

    feh
  ];
}
