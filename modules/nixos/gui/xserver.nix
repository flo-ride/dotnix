{
  services.xserver.xkb.layout = "gb";
  services.xserver.xkb.variant = "extd";

  services.displayManager.gdm = {
    enable = false;
    wayland = true;
  };
  services.displayManager.autoLogin = {
    enable = true;
    user = "floride";
  };
  services.xserver = {
    enable = true;
    exportConfiguration = true;
  };
  services.libinput.enable = true;
}
