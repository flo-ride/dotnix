{ pkgs, ... }: {
  services.tailscale.enable = true;
  services.tailscale.useRoutingFeatures = "both";

  environment.systemPackages = with pkgs; [ wireguard-tools tailscale ];

}
