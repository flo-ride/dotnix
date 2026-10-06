{ config, lib, pkgs, ... }:

let
  cfg = config.modules.services.ai;
in {
  imports = [
    ./ollama.nix
    ./llama-swap.nix
  ];

  options.modules.services.ai = {
    enable = lib.mkEnableOption "AI services (Ollama / Llama-swap)";
    
    backend = lib.mkOption {
      type = lib.types.enum [ "ollama" "llama-swap" "both" ];
      default = "ollama";
      description = "Which backend to use for AI. If both, ollama runs on 11434 and llama-swap on 8080.";
    };

    auth = {
      enable = lib.mkEnableOption "Basic authentication via Nginx reverse proxy";
      
      # For standard htpasswd format (username:hash)
      sopsKey = lib.mkOption {
        type = lib.types.str;
        description = "Name of the sops secret containing the htpasswd content";
        default = "ai-htpasswd";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # If auth is enabled, bind services to localhost only, and Nginx listens on 0.0.0.0:11434
    # If auth is disabled, bind the active service(s) to 0.0.0.0 directly.

    modules.services.ollama = lib.mkIf (cfg.backend == "ollama" || cfg.backend == "both") {
      enable = true;
      host = if cfg.auth.enable then "127.0.0.1" else "0.0.0.0";
      port = if cfg.auth.enable then 11435 else 11434;
    };

    modules.services.llama-swap = lib.mkIf (cfg.backend == "llama-swap" || cfg.backend == "both") {
      enable = true;
      host = if cfg.auth.enable then "127.0.0.1" else "0.0.0.0";
      port = if cfg.backend == "both" then 8080 else (if cfg.auth.enable then 11435 else 11434);
    };

    sops.secrets.${cfg.auth.sopsKey} = lib.mkIf cfg.auth.enable {
      owner = config.services.nginx.user;
    };

    services.nginx = lib.mkIf cfg.auth.enable {
      enable = true;
      virtualHosts."ai-api" = {
        # Listen on 11434 on all interfaces
        listen = [ { addr = "0.0.0.0"; port = 11434; } ];
        
        locations."/" = {
          # Route to whichever service is acting as the primary API on 11435
          proxyPass = "http://127.0.0.1:11435";
          proxyWebsockets = true;
          
          # Basic Auth
          basicAuthFile = config.sops.secrets.${cfg.auth.sopsKey}.path;
        };
      };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.auth.enable [ 11434 ];
  };
}
