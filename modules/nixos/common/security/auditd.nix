{...}: {
  security.auditd.enable = true;
  security.audit = {
    enable = true;
    rules = [
      # Mots de passe et utilisateurs
      "-w /etc/shadow -p wa -k shadow"
      "-w /etc/passwd -p wa -k passwd"
      "-w /etc/group -p wa -k group"

      # Secrets et configurations sensibles
      "-w /home/floride/Documents/Others/dotnix/secrets.yaml -p wa -k sops_secrets"
      "-w /home/floride/Documents/Others/dotnix/ -p wa -k nixos_configs"

      # Clés SSH et GPG (Surveillance des accès en lecture et écriture)
      "-w /home/floride/.ssh/ -p rwa -k ssh_keys"
      "-w /home/floride/.gnupg/ -p rwa -k gpg_keys"

      # Surveillance du système de logs (pour éviter l'effacement de traces)
      "-w /var/log/journal/ -p wa -k systemd_journal"

      # Surveillance des modules kernel (chargement/déchargement suspect)
      "-w /run/current-system/sw/bin/insmod -p x -k kernel_modules"
      "-w /run/current-system/sw/bin/rmmod -p x -k kernel_modules"
      "-w /run/current-system/sw/bin/modprobe -p x -k kernel_modules"
    ];
  };
}
