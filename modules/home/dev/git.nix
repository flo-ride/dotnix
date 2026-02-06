{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [gh glab git-lfs];

  home.shellAliases = {
    g = "git";
    lg = "lazygit";
  };

  programs = {
    lazygit.enable = true;
    # https://nixos.asia/en/git
    git = {
      enable = true;
      lfs.enable = true;

      settings = {
        # User config
        user.name = config.me.fullname;
        user.email = config.me.email;

        # Extra Config
        init.defaultBranch = "master";
        push.autoSetupRemote = true;

        pull.rebase = true;
        pull.ff = "true";

        core.editor = "nvim";
        core.pager = "${pkgs.delta}/bin/delta --dark";

        merge.tool = "fugitive";
        mergetool.fugitive.cmd = "nvim -f -c Gvdiffsplit! $LOCAL $REMOTE $MERGED";

        safe.directory = "*"; # Allow to push my config with git

        alias = {
          mr = "!sh -c 'git fetch $1 merge-requests/$2/head:mr-$1-$2 && git checkout mr-$1-$2' -";
          l = "log --graph --pretty='%Cred%h%Creset - %C(bold blue)<%an>%Creset %s%C(yellow)%d%Creset %Cgreen(%cr)' --abbrev-commit --date=relative";
          whoops = "reset --hard";
          back = "reset --hard HEAD^";
        };
      };

      ignores = [
        ## Syncthing
        "*sync-conflict-*"

        ## Vim/Neovim
        # Swap
        "[._]*.s[a-v][a-z]"
        "[._]*.sw[a-p]"
        "[._]s[a-rt-v][a-z]"
        "[._]ss[a-gi-z]"
        "[._]sw[a-p]"

        # Session
        "Session.vim"
        "Sessionx.vim"

        # Temporary
        ".netrwhist"
        "*~"

        # Auto-generated tag files
        "tags"

        # Persistent undo
        "[._]*.un~"

        ## AI prompt files
        ".gemini/"
        "GEMINI.md"
        "CLAUDE.md"
        "CHATGPT.md"
        "AI.md"
        ".cursorrules"
        ".clineignore"
        ".clinerules"
        ".geminiignore"
      ];
    };
  };
}
