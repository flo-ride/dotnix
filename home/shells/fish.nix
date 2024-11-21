{ pkgs, lib, ... }: {
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
      ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
    '';
    plugins = [
      {
        name = "tide";
        src = pkgs.fishPlugins.tide.src;
      }

      {
        name = "sponge";
        src = pkgs.fishPlugins.sponge.src;
      }

      {
        name = "grc";
        src = pkgs.fishPlugins.grc.src;
      }

      {
        name = "colored-man-pages";
        src = pkgs.fishPlugins.colored-man-pages.src;
      }

      {
        name = "bass";
        src = pkgs.fishPlugins.bass.src;
      }
      {
        name = "done";
        src = pkgs.fishPlugins.done.src;
      }
    ];

    shellAbbrs = {
      gl = "git l";
      gd = "git diff";
      gs = "git status";
      gc = "git commit";
      gca = "git commit --amend";
    };

    shellAliases = {
      v = "nvim";
      c = "clear";
      untar = "tar -xvzf";
      tarc = "tar -cvzf";
      mkdir = "mkdir -vp";
      rm = "rm -riv";
      cp = "cp -riv";
      mv = "mv -iv";
      cat = "bat -p";
      ls = "lsd";
      l = "lsd -al";
      sl = "lsd";
      tree = "lsd --tree";
      # ssh = "TERM = xterm-256color $(which ssh)";
    };
  };
}
