# See /modules/nixos/* for actual settings
# This file is just *top-level* configuration.
{ flake, ... }:

let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports = [
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
    self.nixosModules.default
    self.nixosModules.gui
    self.nixosModules.syncthing
    self.nixosModules.games
    self.nixosModules.vpn
    self.nixosModules.ollama
    {
      home-manager.sharedModules = [
        self.homeModules.dev
        self.homeModules.gui
        self.homeModules.hephaistos
      ];
    }
    ./configuration.nix
  ];
}
