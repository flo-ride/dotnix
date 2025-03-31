{ inputs, self, withSystem, module_args, ... }:
let
  sharedModules = [ ../. ../shells ../programs ../services module_args ];

  desktopModules = with inputs; [ ../wayland ../programs/rofi ../programs/packages.nix ../services/mako.nix ../terminals/alacritty.nix ];

  homeImports = {
    "floride@hephaistos" = [ ./hephaistos ] ++ sharedModules ++ desktopModules ++ [ ../services/syncthing.nix ] ++ [ ../themes/catpuccin ];
    "floride@legion" = [ ./legion ] ++ sharedModules ++ desktopModules ++ [ ../services/syncthing.nix ] ++ [ ../themes/catpuccin ];
    "floride@erge" =  sharedModules ++ [../services/syncthing.nix] ++ [ ../themes/catpuccin ];
  };

  inherit (inputs.home-manager.lib) homeManagerConfiguration;
in {
  imports = [{ _module.args = { inherit homeImports; }; }];

  flake = {
    homeConfigurations = withSystem "x86_64-linux" ({ pkgs, ... }: {
      "floride@hephaistos" = homeManagerConfiguration {
        modules = homeImports."floride@hephaistos" ++ module_args;
        inherit pkgs;
      };
      "floride@legion" = homeManagerConfiguration {
        modules = homeImports."floride@legion" ++ module_args;
        inherit pkgs;
      };
      "floride@erge" = homeManagerConfiguration {
        modules = homeImports."floride@erge" ++ module_args;
        inherit pkgs;
      };
    });
  };
}
