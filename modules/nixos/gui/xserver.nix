{
  services.xserver.xkb.layout = "gb";
  services.xserver.xkb.variant = "extd";
  services.xserver = {
    enable = true;
    exportConfiguration = true;

    displayManager.gdm = {
      enable = true;
      wayland = true;
    };

  };
  services.libinput.enable = true;
}
