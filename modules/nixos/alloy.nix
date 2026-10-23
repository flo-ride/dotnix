{
  config,
  lib,
  ...
}: let
  cfg = config.modules.services.alloy;

  lokiHost = lib.head (
    lib.splitString "/" (lib.removePrefix "https://" (lib.removePrefix "http://" cfg.lokiUrl))
  );
in {
  options.modules.services.alloy = {
    enable = lib.mkEnableOption "Grafana Alloy shipping of the systemd journal to Loki";

    host = lib.mkOption {
      type = lib.types.str;
      default = config.networking.hostName;
      defaultText = lib.literalExpression "config.networking.hostName";
      description = "Value of the `host` label attached to the journal logs.";
    };

    cluster = lib.mkOption {
      type = lib.types.str;
      default = "physical";
      description = "Value of the `cluster` label attached to the journal logs.";
    };

    lokiUrl = lib.mkOption {
      type = lib.types.str;
      default = "https://loki.floride.dev/loki/api/v1/push";
      description = "Loki push endpoint.";
    };

    lokiIngressIp = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        When set, the hostname of `lokiUrl` is resolved to this address through
        /etc/hosts. Useful when the public ingress only accepts private or
        Tailscale source addresses. Set to null to use public DNS resolution.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    # The NixOS module runs Alloy as a DynamicUser with only the
    # `systemd-journal` supplementary group: no root, no extra capability.
    services.alloy.enable = true;

    networking.extraHosts = lib.mkIf (cfg.lokiIngressIp != null) ''
      ${cfg.lokiIngressIp} ${lokiHost}
    '';

    # Alloy keeps HTTP keep-alive connections to the resolved address:
    # restart it whenever /etc/hosts changes.
    systemd.services.alloy.restartTriggers = [config.environment.etc.hosts.source];

    environment.etc."alloy/config.alloy".text = ''
      logging {
        level  = "info"
        format = "logfmt"
      }

      loki.source.journal "host" {
        labels = {
          host    = "${cfg.host}",
          cluster = "${cfg.cluster}",
          origin  = "host",
        }
        forward_to = [loki.write.loki.receiver]
      }

      loki.write "loki" {
        endpoint {
          url = "${cfg.lokiUrl}"
        }
      }
    '';
  };
}
