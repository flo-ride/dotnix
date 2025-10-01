{ flake, pkgs, lib, ... }:
let
  inherit (flake) config inputs;
  inherit (inputs) self;
in
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops.defaultSopsFile = ../../../secrets.yaml;
  sops.age.sshKeyPaths = [ "../../../id_ssh" ];
}
