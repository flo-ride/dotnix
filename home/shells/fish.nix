{ pkgs, lib, ... }: {
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
      ${lib.getExe pkgs.any-nix-shell} fish --info-right | source

      function ros2Source --on-variable PWD
          status --is-command-substitution; and return
          if test -e "install/local_setup.bash"
              bass source install/local_setup.bash
              echo "Configured the folder as a ROS 2 workspace"
          end
      end
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

    ];

    shellAbbrs = {
      # Nix
      ns = "nix shell nixpkgs#";
      nr = "nix run nixpkgs#";
      nrs = "sudo nixos-rebuild switch --flake /etc/nixos/#(hostname)";
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
