{ pkgs, config, lib, inputs, ... }:
# configuration shared by all hosts
{
  environment.systemPackages = [ ];

  # Set your time zone.
  time.timeZone = lib.mkDefault "Europe/Paris";

  console.keyMap = "uk";
  services.xserver = {
    xkb.layout = "gb";
    xkb.variant = "extd";
  };

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    # Prevent installing all glibc supported locales
    supportedLocales = [ "en_US.UTF-8/UTF-8" "fr_FR.UTF-8/UTF-8" ];

    extraLocaleSettings = {
      LC_ADDRESS = "fr_FR.UTF-8";
      LC_IDENTIFICATION = "fr_FR.UTF-8";
      LC_MEASUREMENT = "fr_FR.UTF-8";
      LC_MONETARY = "fr_FR.UTF-8";
      LC_NAME = "fr_FR.UTF-8";
      LC_NUMERIC = "fr_FR.UTF-8";
      LC_PAPER = "fr_FR.UTF-8";
      LC_TELEPHONE = "fr_FR.UTF-8";
      LC_TIME = "fr_FR.UTF-8";
    };
  };

  networking.networkmanager = { enable = true; };

  # pickup pkgs from flake export
  nixpkgs.pkgs = inputs.self.legacyPackages.${config.nixpkgs.system};

  users.users.floride = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "networkmanager" "docker" ];
    shell = pkgs.fish;
  };

  programs = {
    command-not-found.enable = false;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    fish.enable = true;
  };

  # Enable the OpenSSH daemon.
  services = {
    openssh.enable = true;

    # Hardware deamons
    fwupd.enable = true;

  };

  system.stateVersion = lib.mkDefault "24.05";
}
