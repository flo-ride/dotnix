{
  config,
  lib,
  ...
}: let
  cfg = config.modules.gui.xserver;
in {
  options.modules.gui.xserver.enable = lib.mkEnableOption "XServer GUI";

  config = lib.mkIf cfg.enable {
    services.xserver.xkb.layout = "gb";
    services.xserver.xkb.variant = "extd";

    services.xserver = {
      enable = true;
      exportConfiguration = true;
    };
    services.libinput.enable = true;
  };
}
