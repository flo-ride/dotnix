{ ... }: {
  # These VPN needs used + password authentifaction.
  # Enabling autoStart launch the VPN service at the start of the computer
  # and wait the user to input auth username + password.
  # Sometime it even blocks the power off cycle of the compute
  # So autoStart is disabled.
  services.openvpn.servers = {
    atelierVPN = {
      config = '' config /etc/nixos/modules/vpn/atelier.ovpn '';
      autoStart = false;
    };
  };
}
