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
  services.fail2ban.enable = true;
}
