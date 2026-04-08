{
  pkgs,
  lib,
  config,
  ...
}: {
  security.apparmor = {
    enable = true;
    killUnconfinedConfinables = false;
    packages = with pkgs; [apparmor-utils apparmor-profiles];
    policies = {
      # Google Chrome - web browser
      "google-chrome" = {
        state = "enforce";
        profile = ''
          abi <abi/4.0>,
          include <tunables/global>
          ${lib.getBin pkgs.google-chrome}/bin/.google-chrome-stable-wrapped flags=(enforce) {
            include <abstractions/base>
            include <abstractions/audio>
            include <abstractions/dbus-session-strict>
            include <abstractions/fonts>
            include <abstractions/freedesktop.org>
            include <abstractions/gnome>
            include <abstractions/mesa>
            include <abstractions/nameservice>
            include <abstractions/ssl_certs>
            include <abstractions/user-download>
            include <abstractions/vulkan>
            include <abstractions/X>
            capability sys_admin,
            capability sys_chroot,
            capability sys_ptrace,

            network inet stream,
            network inet6 stream,
            network inet dgram,
            network inet6 dgram,
            network netlink raw,

            /nix/store/** r,
            /nix/store/*/lib/** mr,
            /nix/store/*/bin/** rix,

            owner @{HOME}/.config/google-chrome/** rwk,
            owner @{HOME}/.cache/google-chrome/** rwk,
            owner @{HOME}/Downloads/** rw,

            /dev/ r,
            /dev/shm/** rw,
            /dev/dri/** rw,
            /sys/devices/** r,
            /proc/@{pid}/** r,
            /etc/machine-id r,
            /run/user/@{uid}/** rw,

            deny @{HOME}/.ssh/** rwx,
            deny @{HOME}/.gnupg/** rwx,
            deny @{HOME}/.config/git/** rwx,
            deny /etc/shadow r,
          }
        '';
      };

      # Electron apps (Discord, Slack, VSCode, etc.) - common attack vector
      "electron-common" = {
        state = "complain"; # Complain mode - Electron apps vary widely
        profile = ''
          abi <abi/4.0>,
          include <tunables/global>
          /nix/store/*-electron-*/lib/electron/electron flags=(complain) {
            include <abstractions/base>
            include <abstractions/audio>
            include <abstractions/fonts>
            include <abstractions/freedesktop.org>
            include <abstractions/mesa>
            include <abstractions/nameservice>
            include <abstractions/ssl_certs>
            include <abstractions/X>

            network inet stream,
            network inet6 stream,

            /nix/store/** r,
            /nix/store/*/lib/** mr,

            owner @{HOME}/.config/** rwk,
            owner @{HOME}/.cache/** rwk,
            owner @{HOME}/Downloads/** rw,

            /dev/shm/** rw,
            /dev/dri/** rw,
            /proc/@{pid}/** r,
            /run/user/@{uid}/** rw,

            deny @{HOME}/.ssh/** rwx,
            deny @{HOME}/.gnupg/** rwx,
          }
        '';
      };
    };
  };

  # AppArmor Desktop Notifications
  systemd.user.services.apparmor-notify = {
    description = "AppArmor Desktop Notifications";
    enable = true;

    after = ["graphical-session.target"];
    wantedBy = ["graphical-session.target"];
    partOf = ["graphical-session.target"];

    unitConfig.ConditionPathExists = "/var/log/audit/audit.log";

    serviceConfig = {
      # -p: poll mode
      # -s 1: show summary
      # -w 5: wait 5 seconds (to group bursts of notifications)
      ExecStart = "${pkgs.apparmor-utils}/bin/aa-notify -p -s 1 -w 5 -f /var/log/audit/audit.log";
      Restart = "on-failure";
      RestartSec = "10s";
    };
  };
}
