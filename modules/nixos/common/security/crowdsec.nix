{config, ...}: {
  services.crowdsec = {
    enable = true;
    autoUpdateService = true;
  };
}
