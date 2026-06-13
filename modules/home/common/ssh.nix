{...}: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "git.floride.dev" = {
        HostName = "git.floride.dev";
        IdentityFile = "~/.ssh/forgejo_floride.pub";
      };
    };
  };
}
