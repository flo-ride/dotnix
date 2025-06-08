{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Tools
    pavucontrol
    networkmanagerapplet
    blueberry
    wdisplays

    # Dev
    libreoffice

    # Productivity
    flameshot
    xfce.thunar
    (pkgs.discord.override {
      #withOpenASAR = true;
      withVencord = true;
    })
    termius

    # Fun
    spotify
  ];
}
