{
  flake,
  pkgs,
  lib,
  ...
}: let
  inherit (flake) config inputs;
  inherit (inputs) self;
in {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops.defaultSopsFile = ../../../secrets.yaml;
  sops.age.keyFile = "/home/floride/.config/sops/age/keys.txt";

  sops.secrets."ssh/common_ssh_pub" = {
    path = "/home/floride/.ssh/common_ssh.pub";
  };
  sops.secrets."ssh/forgejo_floride_pub" = {
    path = "/home/floride/.ssh/forgejo_floride.pub";
  };

  # Allow sops-nix to fail without crashing the whole home-manager activation.
  # Useful for bootstrapping a new machine where the age key is not yet available.
  systemd.user.services.sops-nix = {
    Service.SuccessExitStatus = [ 0 1 2 127 ];
  };
}
