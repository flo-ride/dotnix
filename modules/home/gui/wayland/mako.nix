{ flake
, lib
, pkgs
, ...
}:
{
  services.mako = {
    enable = true;

    settings = {
      sort = "-time";
      layer = "top";
      background-color = "282a36ef"; # Add opacity
      text-color = "white";
      margin = toString 0;
      padding = toString 16;
      border-size = 0;
      border-radius = 12;
      icons = true;
      default-timeout = 15 * 1000; # 30s
    };
  };
  #icon-path=/usr/share/icons/Papirus-Dark
  #font=JetBrainsMono Nerd Font 10

}
