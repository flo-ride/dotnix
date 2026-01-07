{pkgs, ...}: {
  gtk = {
    enable = true;
    cursorTheme = {
      name = "Bibata-Modern-Classic-Hyprcursor";
      package = pkgs.bibata-cursors;
    };
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
    # theme = {
    # name = "Catppuccin-Mocha-Standard-Blue-dark";
    # package = pkgs.catppuccin-gtk;
    # };
  };
}
