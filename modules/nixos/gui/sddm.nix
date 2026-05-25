{pkgs, ...}: {
  services.displayManager.sddm = {
    enable = true;
    theme = "catppuccin-mocha-mauve";
    wayland.enable = true;
  };

  environment.systemPackages = [
    (pkgs.catppuccin-sddm.override {
      flavor = "mocha";
      accent = "mauve";
    })
  ];

  # Don't force fingreprint AND password (https://wiki.nixos.org/wiki/SDDM)
  security.pam.services.login.fprintAuth = false;
}
