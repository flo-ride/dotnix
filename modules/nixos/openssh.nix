{
  services.openssh = {
    enable = true;
    ports = [42022];
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      AllowAgentForwarding = true;
    };
  };
  networking.firewall.allowedTCPPorts = [42022];
  services.fail2ban.enable = true;
}
