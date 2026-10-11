{
  config,
  pkgs,
  flake,
  lib,
  ...
}: {
  imports = [
    flake.inputs.dms.homeModules.dank-material-shell
    flake.inputs.dms-plugin-registry.nixosModules.default
  ];

  programs.dank-material-shell = {
    enable = true;

    package = (flake.inputs.dms.lib.mkDmsShell pkgs).override {
      extraQtPackages = [
        pkgs.kdePackages.qtwebsockets
      ];
    };

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
      dankKDEConnect.enable = true;
      hydrate.enable = true;
      dankscale.enable = true;
      homeAssistantMonitor.enable = true;
    };
  };

  wayland.windowManager.hyprland = {
    settings = {
      on = [
        {
          _args = [
            "hyprland.start"
            (lib.generators.mkLuaInline ''
              function()
                hl.exec_cmd("hyprctl keyword source ${config.xdg.configHome}/hypr/dms/output.conf")
                hl.exec_cmd("hyprctl keyword source ${config.xdg.configHome}/hypr/dms/colors.conf")
              end
            '')
          ];
        }
      ];
    };
  };

  gtk = {
    # Include dank linux configuration
    gtk3.extraCss = "@import url(\"dank-colors.css\");";
    gtk4.extraCss = "@import url(\"dank-colors.css\");";
    gtk4.theme = config.gtk.theme;
  };
}
