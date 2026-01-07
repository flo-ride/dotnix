{
  plugins = {
    # --- Neogit ---
    neogit.enable = true;

    # --- Gitsigns ---
    # Git integration in the gutter
    gitsigns = {
      enable = true;
      settings.signs = {
        add.text = "✚";
        change.text = "✹";
        delete.text = "-";
        topdelete.text = "-";
        changedelete.text = "-";
      };
    };
  };
}
