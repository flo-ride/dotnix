{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.services.llama-swap;

  modelsDir = "/var/lib/llama-models";

  # Script to download missing models using curl
  downloadScript = pkgs.writeShellScript "download-llama-models" ''
    set -euo pipefail

    ${lib.concatStringsSep "\n" (lib.mapAttrsToList (name: model: ''
        if [ ! -f "${modelsDir}/${name}/${model.file}" ]; then
          echo "Downloading ${model.file} from ${model.repo}..."
          mkdir -p "${modelsDir}/${name}"
          ${lib.getExe pkgs.curl} -C - -L --fail --progress-bar "https://huggingface.co/${model.repo}/resolve/${model.revision}/${model.file}" -o "${modelsDir}/${name}/${model.file}.tmp"
          mv "${modelsDir}/${name}/${model.file}.tmp" "${modelsDir}/${name}/${model.file}"
        else
          echo "Model ${model.file} already exists for ${name}."
        fi
      '')
      cfg.models)}
  '';
in {
  options.modules.services.llama-swap = {
    enable = lib.mkEnableOption "Llama-swap service for model routing";

    package = lib.mkPackageOption pkgs "llama-cpp" {};

    models = lib.mkOption {
      description = "Models to download and configure for llama-swap";
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          repo = lib.mkOption {
            type = lib.types.str;
            example = "Qwen/Qwen2.5-Coder-7B-Instruct-GGUF";
            description = "HuggingFace repository";
          };
          revision = lib.mkOption {
            type = lib.types.str;
            default = "main";
            description = "Repository revision/branch";
          };
          file = lib.mkOption {
            type = lib.types.str;
            example = "qwen2.5-coder-7b-instruct-q4_k_m.gguf";
            description = "Filename in the repository";
          };
          contextSize = lib.mkOption {
            type = lib.types.int;
            default = 8192;
            description = "Context size to pass to llama-server (-c)";
          };
          gpuLayers = lib.mkOption {
            type = lib.types.int;
            default = 999;
            description = "Number of layers to offload to GPU (-ngl)";
          };
          extraArgs = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [];
            description = "Extra arguments to pass to llama-server";
          };
        };
      });
      default = {};
    };
  };

  config = lib.mkIf cfg.enable {
    services.llama-swap = {
      enable = true;
      port = 8080;
      settings = {
        models =
          lib.mapAttrs (name: model: {
            cmd = "${lib.getExe' cfg.package "llama-server"} --port \${PORT} -m ${modelsDir}/${name}/${model.file} -c ${toString model.contextSize} -ngl ${toString model.gpuLayers} ${lib.escapeShellArgs model.extraArgs} --no-webui";
          })
          cfg.models;
      };
    };

    systemd.services.llama-swap = {
      serviceConfig = {
        StateDirectory = "llama-models";
        # Fix possible ROCm/CUDA issues by allowing executable memory
        MemoryDenyWriteExecute = lib.mkForce false;
        # Prevent systemd from killing the service during long model downloads
        TimeoutStartSec = "infinity";

        # --- Fix systemd sandboxing issues ---
        # Allow reading /proc/meminfo (needed by llama-swap to monitor RAM)
        ProcSubset = lib.mkForce "all";
        ProtectProc = lib.mkForce "default";

        # ROCm often needs access to /sys and specific syscalls
        SystemCallFilter = lib.mkForce ["~@clock" "~@module" "~@reboot" "~@swap"];
        ProtectSystem = lib.mkForce "full";
        PrivateUsers = lib.mkForce false;
      };
      path = [pkgs.curl cfg.package];
      preStart = "${downloadScript}";
    };
  };
}
