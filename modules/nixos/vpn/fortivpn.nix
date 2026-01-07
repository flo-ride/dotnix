{pkgs, ...}: {
  environment.systemPackages = with pkgs; [openfortivpn openfortivpn-webview];
}
