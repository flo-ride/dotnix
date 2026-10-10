{...}: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "git.floride.dev" = {
        HostName = "git.floride.dev";
        IdentityFile = "~/.ssh/forgejo_floride.pub";
      };
      "gitlab.com" = {
        HostName = "gitlab.com";
        IdentityFile = "~/.ssh/gitlab.pub";
      };
      "zeus" = {
        HostName = "192.168.1.22";
        IdentityFile = "~/.ssh/common_ssh.pub";
      };
      "hades" = {
        HostName = "37.187.134.12";
        IdentityFile = "~/.ssh/hades_ssh.pub";
      };
      "apollon" = {
        HostName = "192.168.88.1";
        IdentityFile = "~/.ssh/apollon_ssh.pub";
      };
      "cronos" = {
        HostName = "192.168.88.252";
        IdentityFile = "~/.ssh/cronos_ssh.pub";
      };
      "orphee" = {
        HostName = "10.52.0.41";
      };
      "10.52.0.41" = {
        User = "admin";
        KexAlgorithms = "+diffie-hellman-group1-sha1";
        HostKeyAlgorithms = "+ssh-rsa";
        Ciphers = "+aes128-cbc";
      };
    };
  };
}
