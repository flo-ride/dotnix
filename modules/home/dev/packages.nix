{ pkgs, ... }:
{
  home.packages = with pkgs; [
    grc
    lsd
    neofetch
    cargo
    xclip
    gemini-cli
    bitwarden-cli
  ];

  # Programs natively supported by home-manager.
  # They can be configured in `programs.*` instead of using home.packages.
}
