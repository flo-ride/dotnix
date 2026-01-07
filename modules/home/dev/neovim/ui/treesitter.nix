{pkgs, ...}: {
  # --- Treesitter ---
  # The engine for modern syntax highlighting
  plugins.treesitter = {
    enable = true;
    settings = {
      highlight.enable = true;
      indent.enable = true;
    };
  };

  # --- Treesitter Context ---
  # Show context on top
  plugins.treesitter-context.enable = true;
}
