{ pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.useOSProber = true;

  # nixpkgs.hostPlatform = "x86_64-linux";

  networking.hostName = "legion";

  # TODO: Maybe move this
  networking.networkmanager.enable = true;

  # TODO: Maybe move this
  console.keyMap = "uk";

  time.hardwareClockInLocalTime = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = "24.11";

  environment.systemPackages = with pkgs; [
    kicad
  ];
}
