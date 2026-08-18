{...}: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "git.floride.dev" = {
        HostName = "git.floride.dev";
        IdentityFile = "~/.ssh/forgejo_floride.pub";
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
    };
  };
}
