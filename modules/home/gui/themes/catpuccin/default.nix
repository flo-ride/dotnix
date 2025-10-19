{ pkgs, ... }:
{
  imports = [
    ./hypr
    ./swaylock.nix
    ./waybar
    ./alacritty.nix
    # ./cava.nix
  ];

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    # Fonts
    # nerdfonts
    font-awesome
  ];
}
