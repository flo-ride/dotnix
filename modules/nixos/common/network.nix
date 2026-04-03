{lib, ...}: {
  networking.firewall = {
    enable = lib.mkDefault true;
    trustedInterfaces = ["lo"];
    allowPing = lib.mkDefault false; # Plus discret sur le réseau
    logReversePathDrops = true; # Log les paquets suspects pour l'audit
  };
}
