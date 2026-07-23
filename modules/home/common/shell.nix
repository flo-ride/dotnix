{
  pkgs,
  lib,
  ...
}: {
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
        if not set -q SSH_AUTH_SOCK
            set -x SSH_AUTH_SOCK $HOME/.bitwarden-ssh-agent.sock
        end
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
        vim = "nvim";
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
        lgitignore = "ln -sf .git/info/exclude .gitignore_local && echo '.gitignore_local' >> .gitignore_local";
        sshb = "set -x SSH_AUTH_SOCK $HOME/.bitwarden-ssh-agent.sock";
      };
      functions = {
        sops-bw = {
          description = "Fetch SSH key from Bitwarden, convert to age, and set SOPS_AGE_KEY in current session";
          body = ''
            set -l item_name $argv[1]
            if test -z "$item_name"
                set item_name "Generic OpenSSH"
            end

            set -l bw_session $BW_SESSION

            if test -z "$bw_session"
                echo "Unlocking Bitwarden vault..."
                set bw_session (${lib.getExe pkgs.bitwarden-cli} unlock --raw)
                if test $status -ne 0
                    echo "❌ Unlock failed."
                    return 1
                end
                set -gx BW_SESSION "$bw_session"
            end

            echo "Extracting SSH key and converting to age format..."
            set -l age_key (${lib.getExe pkgs.bitwarden-cli} get item "$item_name" --session "$bw_session" | ${lib.getExe pkgs.jq} -r '.sshKey.privateKey // empty' | ${lib.getExe pkgs.ssh-to-age} -private-key 2>/dev/null)

            if test -n "$age_key"
                set -gx SOPS_AGE_KEY "$age_key"
                echo "✅ \$SOPS_AGE_KEY successfully loaded into current Fish session!"
            else
                echo "❌ Failed to retrieve or convert the SSH key."
                return 1
            end
          '';
        };
        with-sops-key = {
          description = "Temporarily write SOPS key to disk, run a command, and remove the key";
          body = ''
            if test -z "$SOPS_AGE_KEY"
                echo "🔑 SOPS_AGE_KEY is not set. Running sops-bw..."
                sops-bw
                if test $status -ne 0
                    return 1
                end
            end

            set -l key_path ~/.config/sops/age/keys.txt
            mkdir -p (dirname $key_path)
            echo "$SOPS_AGE_KEY" > $key_path
            echo "🔐 Temporary SOPS key written to $key_path."

            $argv
            set -l cmd_status $status

            rm -f $key_path
            echo "🧹 Temporary SOPS key removed from disk."

            return $cmd_status
          '';
        };
      };
    };
  };
}
