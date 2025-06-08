{ pkgs, ... }:

let
  # colors = import ../colorschemes.nix; # Custom colorscheme
in
{
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
          "echo; neofetch --disable packages; echo"
        ];
      };

      colors = {
        primary = {
          background = "#080F22";
          foreground = "#77e7f1";
        };
        cursor = {
          text = "0xFF261E";
          cursor = "0xFF261E";
        };
        normal = {
          black =  "#080F22";
          red = "#FDE20D";
          green = "#075AA3";
          yellow = "#2F64C1";
          blue = "#CF39A7";
          magenta = "#4B9EB9";
          cyan = "#02A3E3";
          white = "#77e7f1";
        };
        bright = {
          black =  "#53a1a8";
          red =  "#FDE20D";
          green =  "#075AA3";
          yellow =  "#2F64C1";
          blue =  "#CF39A7";
          magenta =  "#4B9EB9";
          cyan =  "#02A3E3";
          white =  "#77e7f1";
        };
      };
    };
  };
}
