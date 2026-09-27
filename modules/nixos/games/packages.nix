{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    pkgs.prismlauncher
  ];

  hardware.xpadneo.enable = true;
}
