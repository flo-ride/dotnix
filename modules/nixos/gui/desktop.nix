{ config
, pkgs
, inputs
, ...
}:
{

  fonts = {
    packages = with pkgs; [
      meslo-lgs-nf
      # nerdfonts
    ];
    fontDir.enable = true;
  };

  # enable location service
  location.provider = "geoclue2";

  environment.systemPackages = with pkgs; [
    firefox
    librewolf
    bluez
    pipewire
  ];
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs = {
    light.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    dconf.enable = true;
  };

  services = {
    # provide location
    geoclue2 = {
      enable = true;
      appConfig.gammastep = {
        isAllowed = true;
        isSystem = false;
      };
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      jack.enable = true;
      pulse.enable = true;
    };

    # battery info & stuff
    upower.enable = true;

    flatpak.enable = true;
  };

  # Sound has to be disabled with pipewire.
  # sound.enable = false;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };

  security = {
    # userland niceness
    rtkit.enable = true;
  };

  xdg.portal.enable = true;
}
