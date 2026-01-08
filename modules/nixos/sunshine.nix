{pkgs, ...}: let
  sunshine-do = pkgs.writeShellScriptBin "sunshine-do" ''
    ${pkgs.procps}/bin/pkill -USR1 hyprlock
    ${pkgs.hyprland}/bin/hyprctl output create headless SUNSHINE-''${SUNSHINE_APP_ID}
    ${pkgs.hyprland}/bin/hyprctl keyword monitor SUNSHINE-''${SUNSHINE_APP_ID},''${SUNSHINE_CLIENT_WIDTH}x''${SUNSHINE_CLIENT_HEIGHT}@''${SUNSHINE_CLIENT_FPS},auto,1
    ${pkgs.hyprland}/bin/hyprctl monitors -j | ${pkgs.jq}/bin/jq -r '.[] | select(.name | startswith("SUNSHINE-") | not) | .name' | xargs -I {} ${pkgs.hyprland}/bin/hyprctl keyword monitor {},disable
  '';
  sunshine-undo = pkgs.writeShellScriptBin "sunshine-undo" ''
    SUNSHINE_COUNT=$(${pkgs.hyprland}/bin/hyprctl monitors -j | ${pkgs.jq}/bin/jq '[.[] | select(.name | startswith("SUNSHINE-"))] | length')

    if [ "$SUNSHINE_COUNT" -le 1 ]; then
        ${pkgs.hyprland}/bin/hyprctl reload
        sleep 1
        ${pkgs.hyprlock}/bin/hyprlock &
    fi

    ${pkgs.hyprland}/bin/hyprctl output destroy SUNSHINE-''${SUNSHINE_APP_ID}
  '';
in {
  systemd.user.services.sunshine.serviceConfig.ExecStartPre = "${pkgs.coreutils}/bin/sleep 5";
  services.sunshine = {
    enable = true;
    capSysAdmin = true;
    openFirewall = true;
    applications = {
      env = {
        PATH = "$(PATH):$(HOME)/.local/bin";
      };
      apps = [
        {
          name = "Dynamic Hyprland Stream";
          prep-cmd = [
            {
              do = "${sunshine-do}/bin/sunshine-do";
              undo = "${sunshine-undo}/bin/sunshine-undo";
            }
          ];

          exclude-global-prep-cmd = "false";
          auto-detach = "true";
        }
      ];
    };
  };
}
