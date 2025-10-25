{ pkgs, ... }:
{
  gtk = {
    # enable = true;
    cursorTheme = {
      name = "Bibata-Modern-Classic-Hyprcursor";
      package = pkgs.bibata-cursors;
    };
    # theme = {
    # name = "Catppuccin-Mocha-Standard-Blue-dark";
    # package = pkgs.catppuccin-gtk;
    # };
  };
}
