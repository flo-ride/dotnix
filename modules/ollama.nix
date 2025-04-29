{ config, pkgs, inputs, ... }: {
  services.ollama = {
    enable = true;
  };
}
