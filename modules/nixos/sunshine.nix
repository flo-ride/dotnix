{
  pkgs,
  lib,
  ...
}: let
  do-factory = {
    monitorName,
    extraCommands ? "",
  }:
    pkgs.writeShellScriptBin "sunshine-do" ''
      # Turn on screen
      ${pkgs.hyprland}/bin/hyprctl dispatch dpms on

      # Unlock PC
      ${pkgs.procps}/bin/pkill -USR1 hyprlock || true
      ${lib.getExe pkgs.dms} ipc call lock unlock

      # Create SUNSHINE-DESKTOP monitor
      ${pkgs.hyprland}/bin/hyprctl output create headless ${monitorName}

      # Configure SUNSHINE-DESKTOP monitor
      ${pkgs.hyprland}/bin/hyprctl eval "hl.monitor({ output = \"${monitorName}\", mode = \"''${SUNSHINE_CLIENT_WIDTH}x''${SUNSHINE_CLIENT_HEIGHT}@''${SUNSHINE_CLIENT_FPS}'\", scale = 1 })"

      # Disable all monitor except SUNSHINE monitors
      ${pkgs.hyprland}/bin/hyprctl monitors -j | ${pkgs.jq}/bin/jq -r '.[] | select(.name | startswith("SUNSHINE-") | not) | .name' | xargs -I {} ${pkgs.hyprland}/bin/hyprctl eval "hl.monitor({ output = '{}', disabled = true })"

      ${extraCommands}
    '';
  undo-factory = {
    monitorName,
    preCommands ? "",
  }:
    pkgs.writeShellScriptBin "sunshine-undo" ''
      ${preCommands}

      SUNSHINE_COUNT=$(${pkgs.hyprland}/bin/hyprctl monitors -j | ${pkgs.jq}/bin/jq '[.[] | select(.name | startswith("SUNSHINE-"))] | length')

      if [ "$SUNSHINE_COUNT" -le 1 ]; then
          # Reactivate monitors
          ${pkgs.hyprland}/bin/hyprctl monitors all -j | \
          ${pkgs.jq}/bin/jq -r '.[] | select(.disabled == true) | .name' | \
          xargs -I {} ${pkgs.hyprland}/bin/hyprctl keyword monitor {},preferred,auto,1

          sleep 1
          ${lib.getExe pkgs.dms} ipc call lock lock &
      fi

      ${pkgs.hyprland}/bin/hyprctl output destroy ${monitorName}

      if [ "$SUNSHINE_COUNT" -le 1 ]; then
          ${pkgs.hyprland}/bin/hyprctl reload
          ${pkgs.hyprland}/bin/hyprctl reload # Why 2, i don't know but one doesn't work fully
      fi
    '';

  sunshine-do = do-factory {
    monitorName = "SUNSHINE-DESKTOP";
  };
  sunshine-undo = undo-factory {
    monitorName = "SUNSHINE-DESKTOP";
  };

  steam-sunshine-do = do-factory {
    monitorName = "SUNSHINE-STEAM";
    extraCommands = ''
      ${lib.getExe steam-launch-and-wait} steam://open/bigpicture &
    '';
  };

  steam-sunshine-undo = undo-factory {
    monitorName = "SUNSHINE-STEAM";
    preCommands = ''
      ${lib.getExe steam-run-url} steam://close/bigpicture
    '';
  };

  steam-run-url = pkgs.writeShellApplication {
    name = "steam-run-url";
    text = ''
      echo "$1" > "/run/user/$(id --user)/steam-run-url.fifo"
    '';
    runtimeInputs = [
      pkgs.coreutils
    ];
  };
  steam-launch-and-wait = pkgs.writeShellApplication {
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
  services.displayManager.autoLogin = {
    enable = true;
    user = "floride";
  };
  environment.systemPackages = [steam-run-url steam-launch-and-wait];
  hardware.uinput.enable = true;
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
    openFirewall = false;
    applications = {
      env = {
        PATH = "$(PATH):$(HOME)/.local/bin";
      };
      apps = [
        {
          name = "Desktop";
          prep-cmd = [
            {
              do = lib.getExe sunshine-do;
              undo = lib.getExe sunshine-undo;
            }
          ];
          exclude-global-prep-cmd = "false";
          auto-detach = "true";
        }
        {
          name = "Steam Big Picture";
          prep-cmd = [
            {
              do = "${lib.getExe steam-sunshine-do}";
              undo = "${lib.getExe steam-sunshine-undo}";
            }
          ];
          image-path = "steam.png";
        }
        {
          name = "Normal";
          exclude-global-prep-cmd = "false";
          auto-detach = "true";
        }
      ];
    };
  };
}
