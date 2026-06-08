{
  description = "FloRide NixOS Flakes configurations";

  inputs = {
    # NixOS
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    # NixOS Unstable
    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Windows
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    # MacOS
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Any
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

    nixos-unified.url = "github:srid/nixos-unified";

    # Hardware Predefined
    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    # Software inputs
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    # Secrets Management
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    # Theme
    catppuccin.url = "github:catppuccin/nix/release-26.05";

    # DankMaterialShell
    dms.url = "github:AvengeMedia/DankMaterialShell/stable";
    dms.inputs.nixpkgs.follows = "nixpkgs";
    dms-plugin-registry.url = "github:AvengeMedia/dms-plugin-registry";
    dms-plugin-registry.inputs.nixpkgs.follows = "nixpkgs";
    dgop.url = "github:AvengeMedia/dgop";
    dgop.inputs.nixpkgs.follows = "nixpkgs";

    # Neovim
    nixvim.url = "github:nix-community/nixvim/nixos-26.05";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.inputs.flake-parts.follows = "flake-parts";

    # sunshine: 2025.924.154138 -> 2026.516.143833. The version in nixpkgs is
    # ~1yr stale with unfixed security vulnerabilities (upstream label
    # "1.severity: security"). Upstream refactored their build (prebuilt ffmpeg
    # fetch, boost 1.89 pin, renamed systemd unit, new build deps), so this is a
    # package rework rather than a simple version bump. (NixOS/nixpkgs#521906)
    nixpkgs-patch-521906 = {
      url = "https://github.com/NixOS/nixpkgs/pull/521906.diff";
      flake = false;
    };
  };

  # Wired using https://nixos-unified.org/autowiring.html
  outputs = inputs:
    inputs.nixos-unified.lib.mkFlake
    {
      inherit inputs;
      root = ./.;
    };
}
