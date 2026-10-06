{ config, lib, pkgs, ... }:
let
  cfg = config.modules.services.ollama;
in {
  options.modules.services.ollama = {
    enable = lib.mkEnableOption "Ollama service";
    port = lib.mkOption {
      type = lib.types.port;
      default = 11434;
      description = "Port for Ollama to listen on";
    };
    host = lib.mkOption {
      type = lib.types.str;
      default = "0.0.0.0";
      description = "Host for Ollama to listen on";
    };
  };

  config = lib.mkIf cfg.enable {
    services.ollama = {
      enable = true;
    };

    networking.firewall.allowedTCPPorts = [ cfg.port ];

    systemd.services.ollama.serviceConfig = {
      Environment = [ "OLLAMA_HOST=${cfg.host}:${toString cfg.port}" ];
    };

    services.open-webui = {
      enable = true;
      port = 11444;
      environment = {
        ANONYMIZED_TELEMETRY = "False";
        DO_NOT_TRACK = "True";
        SCARF_NO_ANALYTICS = "True";
        OLLAMA_API_BASE_URL = "http://127.0.0.1:${toString cfg.port}/api";
        OLLAMA_BASE_URL = "http://127.0.0.1:${toString cfg.port}";
      };
    };

    environment.systemPackages = with pkgs; [
      oterm
    ];
  };
}
