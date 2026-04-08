{
  pkgs,
  lib,
  config,
  ...
}: {
  # We use the kernel audit system, but can disable the auditd daemon
  # if we want logs to go straight to systemd-journald or manage them via tmpfiles.
  security.auditd.enable = true;
  security.audit = {
    enable = true;
    rules = [
      # Rate limit: cap at 200 events/sec to prevent kauditd hold queue overflow
      "-r 200"

      # --- Exclusions (Reduce noise) ---
      "-a always,exclude -F msgtype=SERVICE_START"
      "-a always,exclude -F msgtype=SERVICE_STOP"
      "-a always,exclude -F msgtype=BPF"
      "-a always,exclude -F msgtype=PROCTITLE"
      "-a always,exclude -F msgtype=CWD"
      # Docker/Network noise
      "-a always,exclude -F msgtype=NETFILTER_CFG"
      "-a always,exclude -F msgtype=NETFILTER_PKT"
      "-a always,exclude -F msgtype=PATH"

      # --- Sensitive File Monitoring ---

      # Passwords and users (identity)
      "-a always,exit -F arch=b64 -S openat,openat2 -F path=/etc/passwd -F perm=wa -k identity"
      "-a always,exit -F arch=b64 -S openat,openat2 -F path=/etc/group -F perm=wa -k identity"
      "-a always,exit -F arch=b64 -S openat,openat2 -F path=/etc/shadow -F perm=wa -k identity"

      # Secrets and sensitive configurations
      "-w /home/floride/Documents/Others/dotnix/secrets.yaml -p wa -k sops_secrets"
      "-a always,exit -F arch=b64 -S openat,openat2 -F dir=/etc/nixos/ -F perm=wa -k nixos-config"

      # Privilege configuration changes
      "-a always,exit -F arch=b64 -S openat,openat2 -F path=/etc/doas.conf -F perm=wa -k privileged_modifications"
      "-a always,exit -F arch=b64 -S openat,openat2 -F path=/etc/ssh/sshd_config -F perm=wa -k sshd_config"

      # SSH and GPG keys
      "-w /home/floride/.ssh/ -p rwa -k ssh_keys"
      "-w /home/floride/.gnupg/ -p rwa -k gpg_keys"

      # --- Privilege Escalation & Execution ---

      # Privilege escalation monitoring
      "-a always,exit -F arch=b64 -S execve -C auid!=euid -F auid!=unset -F euid=0 -k privesc_execve"

      # Privileged command execution
      "-a always,exit -F arch=b64 -S execve -F path=/run/wrappers/bin/doas -k privileged"

      # Kernel module monitoring
      "-a always,exit -F arch=b64 -S init_module,finit_module,delete_module -k kernel_modules"

      # System time/locale modification
      "-a always,exit -F arch=b64 -S settimeofday,adjtimex,clock_settime -k time-change"
      "-a always,exit -F arch=b64 -S sethostname,setdomainname -k system-locale"
    ];
  };

  # Allow wheel group to read audit logs
  systemd.tmpfiles.rules = [
    "d /var/log/audit 0750 root wheel - -"
    "f /var/log/audit/audit.log 0640 root wheel - -"
  ];

  # Workaround for https://github.com/NixOS/nixpkgs/issues/483085
  systemd.services.audit-rules-nixos.serviceConfig.ExecStart = lib.mkForce [
    ""
    (pkgs.writeShellScript "load-audit-rules" ''
      ${pkgs.audit}/bin/auditctl -D
      ${lib.concatMapStringsSep "\n" (
          rule: "${pkgs.audit}/bin/auditctl ${rule}"
        )
        config.security.audit.rules}
      ${pkgs.audit}/bin/auditctl -e 1 || true
      exit 0
    '')
  ];
}
