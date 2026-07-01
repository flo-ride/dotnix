{
  pkgs,
  lib,
  ...
}: {
  imports = [./hardware-configuration.nix];

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.device = "nodev";

  # nixpkgs.hostPlatform = "x86_64-linux";

  networking.hostName = "ares";

  # TODO: Maybe move this
  networking.networkmanager.enable = true;
  networking.nameservers = ["8.8.8.8" "1.1.1.1"];

  # TODO: Maybe move this
  console.keyMap = "uk";

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = "25.11";

  services.xserver.videoDrivers = ["amdgpu"];
  services.ollama = {
    package = lib.mkForce pkgs.ollama-rocm;
    rocmOverrideGfx = "12.0.1";
    environmentVariables = {
      OLLAMA_CONTEXT_LENGTH = "32000";

      # Hide the iGPU (gfx1036) so Ollama only sees the 9070 XT
      HIP_VISIBLE_DEVICES = "0";
      ROCR_VISIBLE_DEVICES = "0";

      # Additional safety override
      HSA_OVERRIDE_GFX_VERSION = "12.0.1";
    };
  };

  modules.services.llama-swap = {
    enable = true;
    package = pkgs.llama-cpp-rocm;
    models = {
      "qwen2.5-coder" = {
        repo = "Qwen/Qwen2.5-Coder-7B-Instruct-GGUF";
        file = "qwen2.5-coder-7b-instruct-q4_k_m.gguf";
        contextSize = 32768;
        extraArgs = [];
      };
      "qwen3.6-27b" = {
        repo = "unsloth/Qwen3.6-27B-GGUF";
        file = "Qwen3.6-27B-Q4_K_M.gguf";
        contextSize = 8192;
        gpuLayers = 33;
        extraArgs = [];
      };
      "qwen3.6-27b-fast" = {
        repo = "unsloth/Qwen3.6-27B-GGUF";
        file = "Qwen3.6-27B-Q3_K_M.gguf";
        contextSize = 32768; # 32K context restored
        gpuLayers = 999;
        # KV Cache Quantization to fit 32K in VRAM (Flash attention is already auto-enabled)
        extraArgs = [ "-ctk" "q8_0" "-ctv" "q8_0" ];
      };
      "gemma4" = {
        repo = "unsloth/gemma-4-12b-it-GGUF";
        file = "gemma-4-12b-it-Q4_K_M.gguf";
        contextSize = 32768;
        extraArgs = [];
      };
    };
  };

  systemd.services.llama-swap.environment = {
    HIP_VISIBLE_DEVICES = "0";
    ROCR_VISIBLE_DEVICES = "0";
    HSA_OVERRIDE_GFX_VERSION = "12.0.1";
  };

  services.printing = {
    enable = true;
    drivers = [pkgs.ptouch-driver];
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.lact.enable = true;
  environment.systemPackages = with pkgs; [
    kicad
    freecad-wayland
    blender
    dbeaver-bin
    bambu-studio
    insomnia
    obs-studio
    easyeffects
    vlc
    ollama-rocm
    ethtool
    amdgpu_top
    ptouch-print
    qpwgraph
    llmfit
    gimp-with-plugins
    ldtk
    krita
  ];

  users.users.floride.openssh.authorizedKeys.keys = lib.mkForce [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAxkm2wAvxsGvqb+F6dGyVta8Il+6FxWOC2n0TYkghvy" # Ares OpenSSH
  ];
}
