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
    shopt -s nullglob

    mkdir -p "${modelsDir}"

    ${lib.optionalString (cfg.models != {}) ''
      # Prune removed model directories
      for d in "${modelsDir}"/*; do
        if [ -d "$d" ]; then
          model_name="$(basename "$d")"
          case "$model_name" in
            ${lib.concatStringsSep "|" (lib.attrNames cfg.models)})
              ;;
            *)
              echo "Pruning removed model directory: $d"
              rm -rf "$d"
              ;;
          esac
        fi
      done
    ''}

    ${lib.concatStringsSep "\n" (lib.mapAttrsToList (name: model: ''
        if [ ! -f "${modelsDir}/${name}/${model.file}" ]; then
          echo "Downloading ${model.file} from ${model.repo}..."
          mkdir -p "${modelsDir}/${name}"
          ${lib.getExe pkgs.curl} -C - -L --fail --progress-bar "https://huggingface.co/${model.repo}/resolve/${model.revision}/${model.file}" -o "${modelsDir}/${name}/${model.file}.tmp"
          mv "${modelsDir}/${name}/${model.file}.tmp" "${modelsDir}/${name}/${model.file}"
        else
          echo "Model ${model.file} already exists for ${name}."
        fi
        ${lib.optionalString (model.mmproj != null) (let
          mmprojRepo = if model.mmproj.repo != null then model.mmproj.repo else model.repo;
          mmprojFile = model.mmproj.file;
          mmprojRev = model.mmproj.revision;
        in ''
          if [ ! -f "${modelsDir}/${name}/${mmprojFile}" ]; then
            echo "Downloading multimodal projector ${mmprojFile} from ${mmprojRepo}..."
            mkdir -p "${modelsDir}/${name}"
            ${lib.getExe pkgs.curl} -C - -L --fail --progress-bar "https://huggingface.co/${mmprojRepo}/resolve/${mmprojRev}/${mmprojFile}" -o "${modelsDir}/${name}/${mmprojFile}.tmp"
            mv "${modelsDir}/${name}/${mmprojFile}.tmp" "${modelsDir}/${name}/${mmprojFile}"
          else
            echo "Multimodal projector ${mmprojFile} already exists for ${name}."
          fi
        '')}
      '')
      cfg.models)}
  '';
in {
  options.modules.services.llama-swap = {
    enable = lib.mkEnableOption "Llama-swap service for model routing";

    backend = lib.mkOption {
      type = lib.types.enum ["cpu" "rocm" "vulkan"];
      default = "cpu";
      description = "llama.cpp compute backend; selects the default package unless `package` is overridden";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8080;
      description = "Port for llama-swap";
    };

    host = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "Host for llama-swap";
    };

    package = lib.mkPackageOption pkgs "llama-cpp" {
      default = [{
        cpu = "llama-cpp";
        rocm = "llama-cpp-rocm";
        vulkan = "llama-cpp-vulkan";
      }.${cfg.backend}];
    };

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
          mmproj = lib.mkOption {
            type = lib.types.nullOr (lib.types.coercedTo
              lib.types.str
              (file: {
                inherit file;
                repo = null;
                revision = "main";
              })
              (lib.types.submodule {
                options = {
                  repo = lib.mkOption {
                    type = lib.types.nullOr lib.types.str;
                    default = null;
                    description = "HuggingFace repository for mmproj (defaults to model repo if null)";
                  };
                  file = lib.mkOption {
                    type = lib.types.str;
                    description = "Filename of mmproj in the repository";
                  };
                  revision = lib.mkOption {
                    type = lib.types.str;
                    default = "main";
                    description = "Repository revision/branch for mmproj";
                  };
                };
              }));
            default = null;
            description = "Multimodal projector file (mmproj) for vision models";
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
          fit = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Enable --fit to automatically adjust context/gpu-layers to fit in GPU memory (prevents OOM crashes)";
          };
          fitTarget = lib.mkOption {
            type = lib.types.int;
            default = 2048;
            description = "Target margin in MiB to leave free on GPU for --fit (default: 2048 MiB to protect a Wayland compositor/UI session)";
          };
          ttl = lib.mkOption {
            type = lib.types.int;
            default = 300;
            description = "Time to live in seconds before automatically unloading the model (e.g., 300 for 5m). Set to 0 to never unload.";
          };
        };
      });
      default = {};
    };
  };

  config = lib.mkIf cfg.enable {
    services.llama-swap = {
      enable = true;
      port = cfg.port;
      listenAddress = cfg.host;
      settings = {
        models =
          lib.mapAttrs (name: model: {
            cmd = lib.concatStringsSep " " (lib.filter (s: s != "") [
              (lib.getExe' cfg.package "llama-server")
              "--port \${PORT}"
              "-m ${modelsDir}/${name}/${model.file}"
              (lib.optionalString (model.mmproj != null) "--mmproj ${modelsDir}/${name}/${model.mmproj.file}")
              "-c ${toString model.contextSize}"
              "-ngl ${toString model.gpuLayers}"
              (lib.optionalString model.fit "--fit on")
              (lib.optionalString model.fit "--fit-target ${toString model.fitTarget}")
              (lib.escapeShellArgs model.extraArgs)
              "--no-webui"
            ]);
            ttl = model.ttl;
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
        SupplementaryGroups = [ "render" "video" ];
      };
      path = [pkgs.curl cfg.package pkgs.rocmPackages.rocm-smi];
      preStart = "${downloadScript}";
    };
  };
}
