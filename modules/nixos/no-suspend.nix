{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.modules.system.no-suspend;
in {
  options.modules.system.no-suspend.enable = lib.mkEnableOption "Disable suspend";
  config = lib.mkIf cfg.enable {
    # TODO@ Check if need enabling
    # systemd.sleep.extraConfig = ''
    #   AllowSuspend=no
    #   AllowHibernation=no
    #   AllowHybridSleep=no
    #   AllowSuspendThenHibernate=no
    # '';
    services.logind.settings.Login = {
      HandleLidSwitchExternalPower = "ignore";
      HandleLidSwitch = "ignore";
    };
  };
}
