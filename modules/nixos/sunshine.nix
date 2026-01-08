{
  pkgs,
  lib,
  ...
}: let
  sunshine-do = pkgs.writeShellScriptBin "sunshine-do" ''
    ${pkgs.procps}/bin/pkill -USR1 hyprlock
    ${pkgs.hyprland}/bin/hyprctl output create headless SUNSHINE-DESKTOP
    ${pkgs.hyprland}/bin/hyprctl keyword monitor SUNSHINE-DESKTOP,''${SUNSHINE_CLIENT_WIDTH}x''${SUNSHINE_CLIENT_HEIGHT}@''${SUNSHINE_CLIENT_FPS},auto,1
    ${pkgs.hyprland}/bin/hyprctl monitors -j | ${pkgs.jq}/bin/jq -r '.[] | select(.name | startswith("SUNSHINE-") | not) | .name' | xargs -I {} ${pkgs.hyprland}/bin/hyprctl keyword monitor {},disable
  '';
  sunshine-undo = pkgs.writeShellScriptBin "sunshine-undo" ''
    SUNSHINE_COUNT=$(${pkgs.hyprland}/bin/hyprctl monitors -j | ${pkgs.jq}/bin/jq '[.[] | select(.name | startswith("SUNSHINE-"))] | length')

    if [ "$SUNSHINE_COUNT" -le 1 ]; then
        ${pkgs.hyprland}/bin/hyprctl reload
        sleep 1
        ${pkgs.hyprlock}/bin/hyprlock &
    fi

    ${pkgs.hyprland}/bin/hyprctl output destroy SUNSHINE-DESKTOP

    if [ "$SUNSHINE_COUNT" -le 1 ]; then
        ${pkgs.hyprland}/bin/hyprctl reload
        ${pkgs.hyprland}/bin/hyprctl reload # Why 2, i don't know but one doesn't work fully
    fi
  '';
  steam-sunshine-do = pkgs.writeShellScriptBin "steam-sunshine-do" ''
    ${pkgs.procps}/bin/pkill -USR1 hyprlock || true
    ${pkgs.hyprland}/bin/hyprctl output create headless SUNSHINE-STEAM
    ${pkgs.hyprland}/bin/hyprctl keyword monitor SUNSHINE-STEAM,''${SUNSHINE_CLIENT_WIDTH}x''${SUNSHINE_CLIENT_HEIGHT}@''${SUNSHINE_CLIENT_FPS},auto,1
    ${pkgs.hyprland}/bin/hyprctl monitors -j | ${pkgs.jq}/bin/jq -r '.[] | select(.name | startswith("SUNSHINE-") | not) | .name' | xargs -I {} ${pkgs.hyprland}/bin/hyprctl keyword monitor {},disable
    ${lib.getExe steam-run-url} steam://open/bigpicture &
  '';

  steam-sunshine-undo = pkgs.writeShellScriptBin "steam-sunshine-undo" ''
    ${pkgs.util-linux}/bin/setsid ${pkgs.steam}/bin/steam steam://close/bigpicture || true
    SUNSHINE_COUNT=$(${pkgs.hyprland}/bin/hyprctl monitors -j | ${pkgs.jq}/bin/jq '[.[] | select(.name | startswith("SUNSHINE-"))] | length')

    if [ "$SUNSHINE_COUNT" -le 1 ]; then
        ${pkgs.hyprland}/bin/hyprctl monitors all -j | \
        ${pkgs.jq}/bin/jq -r '.[] | select(.disabled == true) | .name' | \
        xargs -I {} ${pkgs.hyprland}/bin/hyprctl keyword monitor {},preferred,auto,1
        sleep 1
        ${pkgs.hyprlock}/bin/hyprlock &
    fi

    ${pkgs.hyprland}/bin/hyprctl output destroy SUNSHINE-STEAM

    if [ "$SUNSHINE_COUNT" -le 1 ]; then
        ${pkgs.hyprland}/bin/hyprctl reload
        ${pkgs.hyprland}/bin/hyprctl reload # Why 2, i don't know but one doesn't work fully
    fi
  '';
  steam-run-url = pkgs.writeShellApplication {
    name = "steam-run-url";
    text = ''
      # Write the URL to the FIFO to launch Steam
      echo "$1" > "/run/user/$(id --user)/steam-run-url.fifo"
      # Wait a moment for Steam to start
      sleep 2
      # Wait for Steam to exit by monitoring the process
      while pgrep -x "steam" > /dev/null || pgrep -f "steam.*.sh" > /dev/null; do
        sleep 1
      done
    '';
    runtimeInputs = [
      pkgs.coreutils
      pkgs.procps
    ];
  };
in {
  environment.systemPackages = [steam-run-url];
  systemd.user.services.steam-run-url-service = {
    enable = true;
    description = "Listen and starts steam games by id";
    serviceConfig.Restart = "on-failure";
    script = toString (pkgs.writers.writePython3 "steam-run-url-service" {} ''
      import os
      from pathlib import Path
      import subprocess

      pipe_path = Path(f'/run/user/{os.getuid()}/steam-run-url.fifo')
      try:
          pipe_path.parent.mkdir(parents=True, exist_ok=True)
          pipe_path.unlink(missing_ok=True)
          os.mkfifo(pipe_path, 0o600)
          steam_env = os.environ.copy()
          steam_env["QT_QPA_PLATFORM"] = "wayland"
          while True:
              with pipe_path.open(encoding='utf-8') as pipe:
                  subprocess.Popen(['steam', pipe.read().strip()], env=steam_env)
      finally:
          pipe_path.unlink(missing_ok=True)
    '');
    path = [
      pkgs.gamemode
      pkgs.steam
    ];
  };
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
          name = "Desktop";
          prep-cmd = [
            {
              do = "${sunshine-do}/bin/sunshine-do";
              undo = "${sunshine-undo}/bin/sunshine-undo";
            }
          ];
          exclude-global-prep-cmd = "false";
          auto-detach = "true";
        }
        {
          name = "Steam Big Picture";
          prep-cmd = [
            {
              do = "${steam-sunshine-do}/bin/steam-sunshine-do";
              undo = "${steam-sunshine-undo}/bin/steam-sunshine-undo";
            }
          ];
          image-path = "steam.png";
        }
      ];
    };
  };
}
