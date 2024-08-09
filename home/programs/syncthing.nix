{ lib, pkgs, config, ... }:

{
  services.syncthing = { 
    enable = true; 
  };
}
