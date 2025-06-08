{ config
, pkgs
, inputs
, ...
}:
{
  programs.hyprland.enable = true;
  # add hyprland to display manager sessions
  services.displayManager.sessionPackages = [ pkgs.hyprland ];
  security.pam.services.swaylock = { };
}
