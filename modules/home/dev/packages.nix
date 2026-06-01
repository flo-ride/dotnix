{pkgs, ...}: {
  home.packages = with pkgs; [
    grc
    lsd
    hyfetch
    cargo
    xclip
    opencode
    gemini-cli
    bitwarden-cli
    tldr
  ];

  # Programs natively supported by home-manager.
  # They can be configured in `programs.*` instead of using home.packages.
}
