{...}: {
  services.resolved = {
    enable = true;
    dnssec = "true";
    dnsovertls = "opportunistic";
    fallbackDns = ["9.9.9.9#dns.quad9.net" "1.1.1.1#cloudflare-dns.com"];
  };
}
