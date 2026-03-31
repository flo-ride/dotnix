{pkgs, ...}: {
  services.tailscale.enable = true;
  services.tailscale.useRoutingFeatures = "both";

  networking.firewall.trustedInterfaces = ["tailscale0"];

  environment.systemPackages = with pkgs; [wireguard-tools tailscale];
}
