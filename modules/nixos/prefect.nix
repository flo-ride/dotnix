{ config, ... }:
{
  services.prefect = {
    enable = true;
    database = "sqlite";
    workerPools.default = {
      installPolicy = "if-not-present";
    };
    baseUrl = "http://localhost:4200";
  };
  systemd.services.prefect-worker-default.environment.systemPackages =
    config.services.prefect.package;
}
