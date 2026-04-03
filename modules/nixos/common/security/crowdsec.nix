{config, ...}: {
  services.crowdsec = {
    enable = true;
    autoUpdateService = true;
    openFirewall = true;
    localConfig.
      acquisitions = [
      {
        source = "journalctl";
        journalctl_filter = ["_TRANSPORT=journal"];
        labels.type = "syslog";
      }
      {
        filename = "/var/log/audit/audit.log";
        labels.type = "auditd";
      }
    ];
  };

  services.crowdsec-firewall-bouncer = {
    enable = false;
  };
}
