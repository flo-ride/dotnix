{
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = [pkgs.vulnix];

  # Run vulnix daily
  systemd.services.vulnix-scan = {
    description = "Nix derivations vulnerability scanner";
    script = "${lib.getExe pkgs.vulnix} --system --gc-roots --verbose > /var/log/vulnix.log";
    serviceConfig = {
      Type = "oneshot";
      User = "root";
      Nice = 5;
      IOSchedulingClass = 2;
      IOSchedulingPriority = 6;
    };
  };

  systemd.timers.vulnix-scan = {
    description = "Daily vulnix scan";
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };
}
