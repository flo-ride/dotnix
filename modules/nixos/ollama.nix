{pkgs, ...}: {
  services.ollama = {
    enable = true;
  };

  systemd.services.ollama.serviceConfig = {
    Environment = ["OLLAMA_HOST=0.0.0.0:11434"];
  };

  services.open-webui = {
    enable = true;
    port = 11444;
    environment = {
      ANONYMIZED_TELEMETRY = "False";
      DO_NOT_TRACK = "True";
      SCARF_NO_ANALYTICS = "True";
      OLLAMA_API_BASE_URL = "http://127.0.0.1:11434/api";
      OLLAMA_BASE_URL = "http://127.0.0.1:11434";
    };
  };

  # Add oterm to the systemPackages
  environment.systemPackages = with pkgs; [
    oterm
  ];
}
