{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    pkgs.prismlauncher
  ];
}
