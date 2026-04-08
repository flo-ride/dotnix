{
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = [pkgs.lynis];

  # Run lynis weekly
  systemd.services.lynis-scan = {
    description = "Lynis System Audit";
    script = "${lib.getExe pkgs.lynis} audit system --report-file /var/log/lynis/lynis-report.dat > /dev/null 2>&1";
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };

  systemd.timers.lynis-scan = {
    description = "Weekly Lynis audit";
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "Weekly";
      Persistent = true;
    };
  };
}
