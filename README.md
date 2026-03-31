# FloRide's Dotnix ❄️

This repository contains my personal NixOS and Home Manager configurations, managed with **Nix Flakes** and built on top of [nixos-unified](https://github.com/srid/nixos-unified).

It provides a scalable and modular way to manage multiple machines, from high-end workstations with GPU acceleration to headless servers and WSL environments.

## 🚀 What's Inside

- **OS:** NixOS (Stable 25.11 & Unstable for specific packages)
- **Framework:** `nixos-unified` with `flake-parts` for clean autowiring
- **UI:** [Hyprland](https://hyprland.org/) with a polished [Catppuccin](https://github.com/catppuccin/nix) theme
- **Editor:** [NixVim](https://github.com/nix-community/nixvim) (Neovim configured via Nix)
- **Shell:** Fish with [Tide](https://github.com/IlanCosman/tide) and `any-nix-shell`
- **Secrets:** [sops-nix](https://github.com/Mic92/sops-nix) for encrypted credentials
- **Extras:** Ollama (ROCm), Sunshine/Moonlight streaming, Syncthing, and Steam gaming.

## 🏗️ Architecture

This repository follows the `nixos-unified` directory structure, enabling **autowiring** of flake outputs.

| Directory | Description |
|-----------|-------------|
| `configurations/nixos/` | Per-host NixOS system configurations (e.g., `ares`, `nyx`) |
| `configurations/home/` | Per-user Home Manager configurations (e.g., `floride`) |
| `modules/nixos/` | Reusable NixOS system modules (VPN, Games, GUI, etc.) |
| `modules/home/` | Reusable Home Manager modules (Neovim, Shell, Theme) |
| `modules/flake/` | Flake-level modules (Devshells, Toplevel glue) |

### Current Hosts

- **ares**: Main workstation (AMD CPU/GPU, ROCm Ollama, Hyprland)
- **nyx**: Server/Node (Docker, Syncthing, VPN, Ollama)
- **hephaistos**: Laptop (Framework 13")
- **erge**: Work PC
- **legion**: Old PC (deprecated)

## 🛠️ Usage

I use [just](https://github.com/casey/just) to manage common tasks. Run `just` to see all available commands.

### Apply Configuration
To deploy the configuration for the current host (based on hostname):
```sh
nix run
```
Or for a specific host:
```sh
nix run .#ares
```

### Maintenance
- **Update all inputs:** `just update` (runs `nix flake update`)
- **Lint code:** `just lint` (runs `nix fmt`)
- **Dry-check flake:** `just check`

### Clean Up
To free up disk space by deleting old generations:
```sh
sudo nix-env -p /nix/var/nix/profiles/system --delete-generations +2
sudo nixos-rebuild boot
```

## 🔐 Secrets

Secrets are managed with `sops`. To edit the main secrets file:
```sh
sops secrets.yaml
```

## 🎨 Preview

Configurations include a fully themed Hyprland environment with Waybar, Rofi, and Alacritty/Kitty, all unified under the **Catppuccin** color scheme.

---
*Generated with ❤️ by FloRide's NixOS Flake*
