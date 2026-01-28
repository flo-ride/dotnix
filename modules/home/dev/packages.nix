{
  pkgs,
  flake,
  ...
}: let
  unstablePkgs = flake.inputs.nixos-unstable.legacyPackages.${pkgs.system};
in {
  home.packages = with pkgs; [
    grc
    lsd
    neofetch
    cargo
    xclip
    unstablePkgs.gemini-cli
    bitwarden-cli
    tldr
  ];

  # Programs natively supported by home-manager.
  # They can be configured in `programs.*` instead of using home.packages.
}
