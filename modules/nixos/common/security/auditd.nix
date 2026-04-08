{
  pkgs,
  lib,
  config,
  ...
}: {
  security.auditd.enable = true;
  security.audit = {
    enable = true;
    rules = [
      # --- Sensitive File Monitoring ---

      # Passwords and users
      "-w /etc/shadow -p wa -k shadow"
      "-w /etc/passwd -p wa -k passwd"
      "-w /etc/group -p wa -k group"

      # Secrets and sensitive configurations
      "-w /home/floride/Documents/Others/dotnix/secrets.yaml -p wa -k sops_secrets"
      "-w /home/floride/Documents/Others/dotnix/ -p wa -k nixos_configs"

      # SSH and GPG keys (Monitoring read and write access)
      "-w /home/floride/.ssh/ -p rwa -k ssh_keys"
      "-w /home/floride/.gnupg/ -p rwa -k gpg_keys"

      # Log system monitoring (to prevent trace deletion)
      "-w /var/log/journal/ -p wa -k systemd_journal"

      # --- System Call Monitoring (Syscalls) ---

      # System time modification (useful for corrupting logs or certificates)
      "-a always,exit -F arch=b64 -S settimeofday,adjtimex,clock_settime -k time-change"

      # System locale modification (hostname/domainname)
      "-a always,exit -F arch=b64 -S sethostname,setdomainname -k system-locale"

      # Kernel module monitoring (loading/unloading via syscalls)
      "-a always,exit -F arch=b64 -S init_module,finit_module,delete_module -k kernel_modules"

      # kexec monitoring (loading a new kernel without a classic reboot)
      "-a always,exit -F arch=b64 -S kexec_load -k kexec"
    ];
  };

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
