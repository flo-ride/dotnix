# See /modules/nixos/* for actual settings
# This file is just *top-level* configuration.
{ flake, ... }:

let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports = [
    self.nixosModules.default
    self.nixosModules.syncthing
    self.nixosModules.docker
    self.nixosModules.vpn
    self.nixosModules.ollama
    {
      home-manager.sharedModules = [
        self.homeModules.dev
      ];
    }
    ./configuration.nix
  ];
}
