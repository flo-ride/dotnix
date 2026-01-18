# See /modules/nixos/* for actual settings
# This file is just *top-level* configuration.
{flake, ...}: let
  inherit (flake) inputs;
  inherit (inputs) self;
in {
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    self.nixosModules.default
    self.nixosModules.gui
    self.nixosModules.syncthing
    self.nixosModules.games
    self.nixosModules.docker
    self.nixosModules.vpn
    self.nixosModules.ollama
    self.nixosModules.sunshine
    self.nixosModules.no-suspend
    self.nixosModules.vm
    {
      home-manager.sharedModules = [
        self.homeModules.dev
        self.homeModules.gui
        self.homeModules.ares
      ];
    }
    ./configuration.nix
  ];
}
