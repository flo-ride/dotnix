{
  pkgs,
  lib,
  ...
}: {
  services.udiskie = {
    enable = true;
    settings = {
      program_options = {
        file_manager = "${lib.getExe pkgs.thunar}";
        tray = "auto";
      };
    };
  };
}
