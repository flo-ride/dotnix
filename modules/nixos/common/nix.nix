{ config, pkgs, lib, ... }:


{
  # To use the `nix` from `inputs.nixpkgs` on templates using the standalone `home-manager` template

  # `nix.package` is already set if on `NixOS` or `nix-darwin`.
  # TODO: Avoid setting `nix.package` in two places. Does https://github.com/juspay/nixos-unified-template/issues/93 help here?
  nix.package = lib.mkDefault pkgs.nix;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;
  nix.settings.builders-use-substitutes = true;
  nix.settings.flake-registry = "/etc/nix/registry.json";

  nixpkgs.config.allowUnfree = true;

  # for direnv GC roots
  nix.settings.keep-derivations = true;
  nix.settings.keep-outputs = true;

  nix.settings.sandbox = true; # Enable sandboxing for testing packages

  nix.settings.substituters = [
    "https://nix-community.cachix.org"
    "https://cache.nixos.org/"
  ];
  nix.settings.trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  ];

  programs =
    {
      fish.enable = true;
    };


  # Use this here for fixing nix run error (even if it's useless)
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  time.timeZone = lib.mkDefault "Europe/Paris";

  console.keyMap = "uk";

  environment.systemPackages = with pkgs; [ vim git wget curl ];
}
