{pkgs, ...}: {
  imports = [./tailscale.nix ./fortivpn.nix];

  environment.systemPackages = with pkgs; [protonvpn-gui];
}
