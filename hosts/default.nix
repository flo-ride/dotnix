{ inputs, self, withSystem, sharedModules, desktopModules, homeImports, ... }: {
  flake.nixosConfigurations = withSystem "x86_64-linux" ({ system, ... }: {
    hephaistos = inputs.nixpkgs.lib.nixosSystem {
      inherit system;

      modules = [
        inputs.nixos-hardware.nixosModules.framework-13-7040-amd
        ./hephaistos

        ../modules/security.nix
        ../modules/clamav.nix
        ../modules/doas.nix
        ../modules/xserver.nix
        ../modules/hyprland.nix
        ../modules/desktop.nix
        ../modules/syncthing.nix
        ../modules/tailscale.nix
        ../modules/nix-ld.nix
        ../modules/envfs.nix
        ../modules/games.nix
        ../modules/docker.nix


        {
          home-manager.users.floride.imports = homeImports."floride@hephaistos";
        }
      ] ++ sharedModules ++ desktopModules;
    };
    legion = inputs.nixpkgs.lib.nixosSystem {
      inherit system;

      modules = [
        inputs.nixos-hardware.nixosModules.lenovo-legion-y530-15ich
        ./legion

        ../modules/security.nix
        ../modules/clamav.nix
        ../modules/doas.nix
        ../modules/xserver.nix
        ../modules/hyprland.nix
        ../modules/desktop.nix
        ../modules/syncthing.nix
        ../modules/tailscale.nix
        ../modules/nix-ld.nix
        ../modules/envfs.nix
        ../modules/games.nix
        ../modules/docker.nix

        { home-manager.users.floride.imports = homeImports."floride@legion"; }
      ] ++ sharedModules ++ desktopModules;
    };
  });
}
