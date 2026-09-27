{
  lib,
  config,
  ...
}: let
  isNoSuspend = lib.attrByPath ["modules" "system" "no-suspend" "enable"] false config;
in {
  # ClamAV is an open source antivirus engine for detecting trojans, viruses, malware & other malicious threats.
  services.clamav = {
    updater.enable = true;
    daemon.enable = true;
  };

  # Daily scan of the home directory (only on no-suspend devices)
  systemd.services.clamav-scan = lib.mkIf isNoSuspend {
    description = "Daily ClamAV scan";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/run/current-system/sw/bin/clamscan -r /home/floride";
      Nice = 19;
      IOSchedulingClass = "idle";
    };
    startAt = "*-*-* 03:00:00";
  };
}
