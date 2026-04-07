{pkgs, ...}: {
  networking.networkmanager.plugins = [pkgs.networkmanager-fortisslvpn];

  environment.systemPackages = with pkgs; [
    openfortivpn
    openfortivpn-webview
    networkmanager-fortisslvpn
  ];

  networking.firewall.allowedTCPPorts = [8020];
  networking.firewall.trustedInterfaces = ["ppp+"];
}
