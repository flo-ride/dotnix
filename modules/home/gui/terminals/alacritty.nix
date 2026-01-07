{pkgs, ...}: let
  # colors = import ../colorschemes.nix; # Custom colorscheme
in {
  programs.alacritty = {
    enable = true;

    settings = {
      general.live_config_reload = true;

      window = {
        title = "Terminal";
        opacity = 0.7;
      };

      font = {
        normal = {
          family = "MesloLGS NF";
          style = "Regular";
        };
        bold = {
          family = "MesloLGS NF";
          style = "Bold";
        };
        italic = {
          family = "MesloLGS NF";
          style = "Italic";
        };
        bold_italic = {
          family = "MesloLGS NF";
          style = "Bold Italic";
        };
        size = 10.0;
      };

      cursor.style = "Underline";

      terminal.shell = {
        program = "${pkgs.fish}/bin/fish";
        args = [
          "--init-command"
          "echo; ${pkgs.neofetch}/bin/neofetch --disable packages; echo"
        ];
      };
    };
  };
}
