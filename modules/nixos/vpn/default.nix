{ pkgs, ... }:
{
  imports = [ ./tailscale.nix ];

  environment.systemPackages = with pkgs; [ protonvpn-gui protonvpn-cli ];
}
