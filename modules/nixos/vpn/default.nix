{pkgs, ...}: {
  imports = [./tailscale.nix];

  environment.systemPackages = with pkgs; [proton-vpn];
}
