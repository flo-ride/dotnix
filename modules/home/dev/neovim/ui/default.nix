{...}: {
  plugins = {
    # --- Colorizer ---
    # Highlights hex codes like #ff0000 directly in the editor
    colorizer.enable = true;

    # --- Todo Comments ---
    # Highlights TODO, FIXME, etc.
    todo-comments.enable = true;

    # --- Web Devicons ---
    # Provides file type icons for Neovim.
    mini-icons.enable = true;
    mini-icons.mockDevIcons = true;

    # --- Mini.Animate ---
    # Provides smooth scrolling and window animations
    mini-animate.enable = true;

    # --- ToggleTerm ---
    toggleterm = {
      enable = true;
      settings = {
        direction = "float";
        float_opts = {border = "rounded";};
      };
    };

    # --- Trouble ---
    # Diagnostic list
    trouble.enable = true;
  };
}
