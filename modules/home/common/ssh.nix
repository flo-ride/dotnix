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
      "zeus 192.168.1.22" = {
        HostName = "192.168.1.22";
        IdentityFile = "~/.ssh/common_ssh.pub";
      };
      "hades 37.187.134.12" = {
        HostName = "37.187.134.12";
        User = "floride";
        Port = 42022;
        IdentityFile = "~/.ssh/hades_ssh.pub";
        IdentitiesOnly = "yes";
      };
      "apollon 10.52.0.1" = {
        HostName = "10.52.0.1";
        User = "admin";
        Port = 42022;
        IdentityFile = "~/.ssh/apollon_ssh.pub";
        IdentitiesOnly = "yes";
      };
      "cronos 10.52.10.10" = {
        HostName = "10.52.10.10";
        User = "floride";
        Port = 42022;
        IdentityFile = "~/.ssh/cronos_ssh.pub";
        IdentitiesOnly = "yes";
      };
      "delphi 10.50.0.10" = {
        HostName = "10.50.0.10";
        User = "floride";
        Port = 42022;
        IdentityFile = "~/.ssh/common_ssh.pub";
      };
      "hestia 10.50.0.11" = {
        HostName = "10.50.0.11";
        User = "floride";
        Port = 42022;
        IdentityFile = "~/.ssh/common_ssh.pub";
      };
      "argos 10.50.0.12" = {
        HostName = "10.50.0.12";
        User = "floride";
        Port = 42022;
        IdentityFile = "~/.ssh/common_ssh.pub";
      };
      "orphee 10.52.0.41" = {
        User = "admin";
        KexAlgorithms = "+diffie-hellman-group1-sha1";
        HostKeyAlgorithms = "+ssh-rsa";
        Ciphers = "+aes128-cbc";
      };
    };
  };
}
