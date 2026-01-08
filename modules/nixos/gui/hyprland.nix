{
  config,
  pkgs,
  inputs,
  ...
}: {
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };
  # add hyprland to display manager sessions
  services.displayManager.sessionPackages = [pkgs.hyprland];
}
