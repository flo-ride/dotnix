{pkgs, ...}: {
  home.packages = with pkgs; [
    grc
    lsd
    hyfetch
    cargo
    xclip
    opencode
    antigravity
    bitwarden-cli
    tldr
    mcp-nixos
    playwright
    playwright-mcp
  ];

  # Programs natively supported by home-manager.
  # They can be configured in `programs.*` instead of using home.packages.
}
