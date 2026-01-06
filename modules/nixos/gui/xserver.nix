{
  services.xserver.xkb.layout = "gb";
  services.xserver.xkb.variant = "extd";

  services.displayManager.gdm = {
    enable = true;
    wayland = true;
  };
  services.xserver = {
    enable = true;
    exportConfiguration = true;
  };
  services.libinput.enable = true;
}
