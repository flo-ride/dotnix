{ ... }:
let wallpaper = ../../../../misc/wallpaper/jet_set_radio_alien.jpg;
in {
  home.file.".config/hypr/wallpaper.jpg".source = wallpaper;
  home.file.".config/hypr/wallpaper.jpg".target = ".config/hypr/wallpaper.jpg";

  home.file.".config/hypr/hyprpaper.conf".text = ''
    ipc = on
    preload  = ~/.config/hypr/wallpaper.jpg
    wallpaper = ,~/.config/hypr/wallpaper.jpg
  '';
}
