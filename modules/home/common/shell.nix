{ pkgs, ... }:
{
  programs = {
    bash = {
      enable = true;
      initExtra = ''
        # Custom bash profile goes here
      '';
    };

    zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      envExtra = ''
        # Custom ~/.zshenv goes here
      '';
      profileExtra = ''
        # Custom ~/.zprofile goes here
      '';
      loginExtra = ''
        # Custom ~/.zlogin goes here
      '';
      logoutExtra = ''
        # Custom ~/.zlogout goes here
      '';
    };

    fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting # Disable greeting
        set -x SSH_AUTH_SOCK $HOME/.bitwarden-ssh-agent.sock
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
      };
    };
  };
}
