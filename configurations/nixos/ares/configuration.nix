{
  pkgs,
  flake,
  ...
}: {
  imports = [./hardware-configuration.nix];

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.device = "nodev";

  # nixpkgs.hostPlatform = "x86_64-linux";

  networking.hostName = "ares";

  # TODO: Maybe move this
  networking.networkmanager.enable = true;
  networking.nameservers = ["8.8.8.8" "1.1.1.1"];

  # TODO: Maybe move this
  console.keyMap = "uk";

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = "25.11";

  services.xserver.videoDrivers = ["amdgpu"];
  services.ollama = {
    acceleration = "rocm";
    rocmOverrideGfx = "12.0.1";
    environmentVariables = {
      # Hide the iGPU (gfx1036) so Ollama only sees the 9070 XT
      # HIP_VISIBLE_DEVICES = "0" usually targets the discrete card
      HIP_VISIBLE_DEVICES = "0";
      # Additional safety override
      HSA_OVERRIDE_GFX_VERSION = "12.0.1";
    };
  };

  services.lact.enable = true;
  environment.systemPackages = with pkgs; [
    kicad
    freecad-wayland
    blender
    dbeaver-bin
    bambu-studio
    insomnia
    obs-studio
    easyeffects
    vlc
    ollama-rocm
    ethtool
  ];
}
