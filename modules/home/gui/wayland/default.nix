{pkgs, ...}:
# Wayland config
{
  imports = [
    ./hyprland
    ./dms.nix
  ];

  home.packages = with pkgs; [
    # screenshot
    grim
    slurp

    # Clipboard manager
    cliphist

    # utils
    # ocrScript
    wf-recorder
    wl-clipboard
    wlr-randr
  ];

  xdg.configFile = {
    # General environment
    "uwsm/env".text = ''
      export ELECTRON_OZONE_PLATFORM_HINT=auto
      export NIXOS_OZONE_WL=1
      export ELM_DISPLAY=wl
      export SDL_VIDEODRIVER=wayland
    '';

    # Hyprland-specific
    "uwsm/env-hyprland".text = '''';
  };

  # make stuff work on wayland
  home.sessionVariables = {
    _JAVA_AWT_WM_NONREPARENTING = "1";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "xcb;wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    SDL_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";
    NIXOS_OZONE_WL = "1";
  };
}
