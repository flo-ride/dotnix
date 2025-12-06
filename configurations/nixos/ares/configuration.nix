{ pkgs, prev, flake, ... }:

let
  inherit (flake) inputs;
  inherit (inputs) self;

  unstable = inputs.nixos-unstable.legacyPackages.${pkgs.system};
in
{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.device = "nodev";

  # nixpkgs.hostPlatform = "x86_64-linux";

  networking.hostName = "ares";

  # TODO: Maybe move this
  networking.networkmanager.enable = true;
  networking.nameservers = [ "8.8.8.8" "1.1.1.1" ];

  # TODO: Maybe move this
  console.keyMap = "uk";

  time.hardwareClockInLocalTime = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = "25.11";
}
