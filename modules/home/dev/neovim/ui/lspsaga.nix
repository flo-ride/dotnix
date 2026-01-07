{
  plugins.lspsaga = {
    enable = true;

    settings = {
      ui = {
        border = "single";
        code_action = "";
      };

      # Icons and Signs
      diagnostic = {
        text_hl_follow = false;
        extend_can_edit = true;
      };
      code_action = {
        show_server_name = true;
        extend_gitsigns = true;
      };
    };
  };
}
