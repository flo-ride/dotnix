{
  config,
  pkgs,
  flake,
  ...
}: {
  imports = [
    flake.inputs.dms.homeModules.dank-material-shell
    flake.inputs.dms-plugin-registry.modules.default
  ];

  programs.dank-material-shell = {
    enable = true;
    dgop.package = flake.inputs.dgop.packages.${pkgs.stdenv.hostPlatform.system}.default;

    systemd = {
      enable = true; # Systemd service for auto-start
      restartIfChanged = true; # Auto-restart dms.service when dms-shell changes
    };

    enableSystemMonitoring = true; # System monitoring widgets (dgop)
    enableVPN = true; # VPN management widget
    enableDynamicTheming = true; # Wallpaper-based theming (matugen)
    enableAudioWavelength = true; # Audio visualizer (cava)
    enableCalendarEvents = true; # Calendar integration (khal)
    enableClipboardPaste = true; # Manage clipboard history

    plugins = {
      dankBatteryAlerts.enable = true;
      discordVoice.enable = true;
      dankKDEConnect.enable = true;
      hydrate.enable = true;
      tailscale.enable = true;
    };
  };

  wayland.windowManager.hyprland.settings.source = [
    "${config.xdg.configHome}/hypr/dms/outputs.conf"
    "${config.xdg.configHome}/hypr/dms/colors.conf"
  ];

  gtk = {
    # Include dank linux configuration
    gtk3.extraCss = "@import url(\"dank-colors.css\");";
    gtk4.extraCss = "@import url(\"dank-colors.css\");";
    gtk4.theme = config.gtk.theme;
  };
}
