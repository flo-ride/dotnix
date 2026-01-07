{flake, ...}: let
  inherit (flake) inputs;
  inherit (inputs) self;
in {
  imports = [
    self.homeModules.common
  ];

  me = {
    username = "floride";
    fullname = "Flo Ride";
    email = "43076999+flo-ride@users.noreply.github.com";
  };

  home.stateVersion = "24.11";
}
