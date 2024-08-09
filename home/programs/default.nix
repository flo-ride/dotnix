{ config, ... }: {
  imports =
    [ ./git.nix ./nvim ./packages.nix ./rofi ./swaylock.nix ./waybar.nix ./syncthing.nix ];
}
