{
  config,
  pkgs,
  lib,
  ...
}: {
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
}
