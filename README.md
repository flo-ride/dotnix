# Dotnix

> By Florian "FloRide" Reimat

## About

This is my NixOS configuration using Flake for all my computers and servers.  
This config allow me to have per-machine configuration (e.g. modules, hardware specific) AND per-user per-machine configuration (e.g. profiles, workspaces, ...).

Some of the noticeable things I use :

- Nix with Flakes built on top of unstable
- Home-manager for per-user configuration
- Wayland (Hyprland, Hyprpaper, Hyprlock)
- DoAs (alternative to sudo)
- Allacritty terminal, Fish as shell
- Tailscale and OpenVPN

## 🗃️ Contents

- [home](home): my [Home Manager](https://github.com/nix-community/home-manager) config
- [home/profiles](home/profiles): per-user-per-computer configuration
- [home/themes](home/themes): Theming-only configuration
- [hosts](hosts): computer-specific configurations
- [lib](lib): helper functions
- [lib/theme](lib/theme): colors definition for theming
- [modules](modules): common NixOS system configs

## How to ?
### Apply config

```sh
sudo nixos-rebuild <switch/boot> --flake /path/to/this#<computer> [--impure]
```

### Update flakes

```sh
nix flake update
```

## Links
- [First Tutorial](https://ghedam.at/24353/tutorial-getting-started-with-home-manager-for-nix)
- [Home Inspiration](https://github.com/an-nihil00/nixhome)
- [Vinetos Configuration](https://github.com/Vinetos/dotnix)
- [Gvolpe Configuration](https://github.com/gvolpe/nix-config.git)
- [Old Config](https://github.com/FloRide1/nixhome)
