{ inputs, self, withSystem, module_args, ... }:
let
  sharedModules = [ ../. ../shells module_args ];

  desktopModules = with inputs; [ ../wayland ];

  homeImports = {
    "floride@hephaistos" = sharedModules ++ desktopModules ++ [ ./hephaistos ]
      ++ [ ../themes/catpuccin ];

    "floride@legion" = sharedModules ++ desktopModules ++ [ ./legion ]
      ++ [ ../themes/catpuccin ];
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
    });
  };
}
