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
    };
  };
}
