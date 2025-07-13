# See /modules/nixos/* for actual settings
# This file is just *top-level* configuration.
{ flake, ... }:

let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-legion-y530-15ich
    self.nixosModules.default
    self.nixosModules.gui
    self.nixosModules.syncthing
    self.nixosModules.games
    self.nixosModules.docker
    self.nixosModules.vpn
    self.nixosModules.ollama
    {
      home-manager.sharedModules = [
        self.homeModules.dev
        self.homeModules.gui
        self.homeModules.legion
      ];
    }
    ./configuration.nix
  ];
}
