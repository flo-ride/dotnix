{ _inputs, inputs, self, default, ... }:
let
  module_args = {
    _module.args = {
      inputs = _inputs;
      inherit default;
    };
  };
in {
  imports = [{
    _module.args = {
      inherit module_args;

      sharedModules = [
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }

        inputs.home-manager.nixosModule
        module_args
        ./minimal.nix
        ./nix.nix
        ./security.nix
      ];

      desktopModules = [ ./hyprland.nix ];
    };
  }];
}
