{ ... }:
{
  # ClamAV is an open source antivirus engine for detecting trojans, viruses, malware & other malicious threats.
  services.clamav = {
    updater.enable = true;
    daemon.enable = true;
  };
}
