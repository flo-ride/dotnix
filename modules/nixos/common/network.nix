{lib, ...}: {
  networking.firewall = {
    enable = lib.mkDefault true;
    allowPing = lib.mkDefault false; # Plus discret sur le réseau
    logReversePathDrops = true; # Log les paquets suspects pour l'audit
  };
}
