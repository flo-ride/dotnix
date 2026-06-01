{
  flake,
  pkgs,
  ...
}: let
  inherit (flake) inputs;
in {
  imports = [
    ./hypr
    ./alacritty.nix
    ./gtk.nix
    # ./cava.nix
    inputs.catppuccin.homeModules.catppuccin
  ];

  fonts.fontconfig.enable = true;

  catppuccin = {
    enable = true;
    hyprland.enable = false;
    waybar.enable = false; # Override
  };

  home.packages = with pkgs; [
    # Fonts
    # nerdfonts
    font-awesome
  ];

  dconf.enable = true;
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };
}
