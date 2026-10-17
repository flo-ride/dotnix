{
  pkgs,
  flake,
  ...
}: let
  unstablePkgs = flake.inputs.nixos-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
  home.packages = with pkgs; [
    grc
    lsd
    hyfetch
    cargo
    xclip
    unstablePkgs.opencode
    bitwarden-cli
    tldr
    mcp-nixos
    mcp-grafana
    playwright
    playwright-mcp
  ];

  # Programs natively supported by home-manager.
  # They can be configured in `programs.*` instead of using home.packages.
}
