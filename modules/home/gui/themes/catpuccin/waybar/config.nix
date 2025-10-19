{ config
, pkgs
, default
, ...
}:
{
  # Add hyprctl to waybar env  = https://github.com/hyprwm/Hyprland/issues/1835
  # systemd.user.services.waybar.Service.Environment = "PATH=/run/wrappers/bin =${pkgs.hyprland}/bin";

  programs.waybar.settings = {
    mainBar = {
      layer = "top";
      position = "top";

      modules-left = [
        "hyprland/workspaces"
        "custom/music"
      ];
      modules-center = [
        "pulseaudio"
        "backlight"
        "battery"
        "clock"
      ];
      modules-right = [
        "network"
        "bluetooth"
        "custom/lock"
        "custom/power"
      ];

      "hyprland/workspaces" = {
        "disable-scroll" = true;
        "sort-by-name" = true;
        "format" = " {name} ";
        "format-icons" = {
          "default" = "";
        };
      };
      "network" = {
        "format-wifi" = " {icon} {essid} ";
        "format-icons" = [
          "󰤟"
          "󰤢"
          "󰤥"
          "󰤨"
        ];
        "format-ethernet" = "󰈀 {ipaddr}/{cidr} ";
        "format-disconnected" = "";
      };

      "bluetooth" = {
        "format" = " ";
        "format-disabled" = "";
        "format-connected" = " {num_connections}";
        "tooltip-format" = "{controller_alias}\t{controller_address}";
        "tooltip-format-connected" = "{controller_alias}\t{controller_address}\n\n{device_enumerate}";
        "tooltip-format-enumerate-connected" = "{device_alias}\t{device_address}";
      };
      "tray" = {
        "icon-size" = 21;
        "spacing" = 10;
      };
      "custom/music" = {
        "format" = "  {}";
        "escape" = true;
        "interval" = 5;
        "tooltip" = false;
        "exec" = "${pkgs.playerctl}/bin/playerctl metadata --format='{{ title }}'";
        "on-click" = "${pkgs.playerctl}/bin/playerctl play-pause";
        "max-length" = 50;
      };
      "clock" = {
        "timezone" = "Europe/Paris";
        "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        "format-alt" = " {:%d/%m/%Y}";
        "format" = " {:%H:%M}";
      };
      "backlight" = {
        "device" = "intel_backlight";
        "format" = "{icon} {percent}%";
        "format-icons" = [ "" "" "" "" "" "" "" "" "" ];
      };
      "battery" = {
        "states" = {
          "warning" = 30;
          "critical" = 15;
        };
        "format" = "{icon} {capacity}%";
        "format-charging" = "";
        "format-plugged" = "";
        "format-icons" = [ "" "" "" "" "" "" "" "" "" "" "" "" ];
      };
      "pulseaudio" = {
        "scroll-step" = 1;
        "format" = "{icon} {volume}%";
        "format-muted" = "";
        "format-icons" = {
          "default" = [ "" "" " " ];
        };
        "on-click" = "${pkgs.pavucontrol}/bin/pavucontrol";
      };
      "custom/lock" = {
        "tooltip" = false;
        "on-click" = "sh -c '(sleep 0.5s; ${pkgs.swaylock}/bin/swaylock --grace 0)' & disown";
        "format" = "";
      };
      "custom/power" = {
        "tooltip" = false;
        "on-click" = "${pkgs.wlogout}/bin/wlogout &";
        "format" = "襤";
      };
    };
  };
}
