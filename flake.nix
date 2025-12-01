{
  description = "FloRide NixOS Flakes configurations";

  inputs = {
    # NixOS
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    # NixOS Unstable
    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Windows
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    # MacOS
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Any
    home-manager.url = "github:nix-community/home-manager/release-25.11";
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
    catppuccin.url = "github:catppuccin/nix/release-25.05";

    # TODO:
    # nixvim.url = "github:nix-community/nixvim";
    # nixvim.inputs.nixpkgs.follows = "nixpkgs";
    # nixvim.inputs.flake-parts.follows = "flake-parts";
  };

  # Wired using https://nixos-unified.org/autowiring.html
  outputs = inputs:
    inputs.nixos-unified.lib.mkFlake
      { inherit inputs; root = ./.; };
}
