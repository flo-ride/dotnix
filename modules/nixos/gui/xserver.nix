{
  services.xserver.xkb.layout = "gb";
  services.xserver.xkb.variant = "extd";

  services.xserver = {
    enable = true;
    exportConfiguration = true;
  };
  services.libinput.enable = true;
}
