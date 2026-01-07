{
  config,
  pkgs,
  lib,
  vimUtils,
  flake,
  ...
}: let
  inherit (flake) inputs;
  inherit (inputs) self;

  unstable = import inputs.nixos-unstable {
    system = pkgs.system;
    config.allowUnfree = true;
  };

  # installs a vim plugin from git with a given tag / branch
  pluginGit = ref: repo:
    pkgs.vimUtils.buildVimPlugin {
      pname = "${lib.strings.sanitizeDerivationName repo}";
      version = ref;
      src = builtins.fetchGit {
        url = "https://github.com/${repo}.git";
        ref = ref;
      };
    };

  # always installs latest version
  plugin = pluginGit "HEAD";
  # https://github.com/breuerfelix/nixos/blob/main/shell/vim/init.nix
  # builtins.concatStringsSep "\n" [ (lib.strings.fileContents ./init.vim) ];
in {
  programs.neovim = {
    enable = true;
    vimAlias = true;
    defaultEditor = true;

    withNodeJs = true;
    withPython3 = true;
    withRuby = true;

    extraConfig = builtins.concatStringsSep "\n" [
      (lib.strings.fileContents ./base.vim)
      ''
        lua << EOF
        ${lib.strings.fileContents ./lua/others/ai.lua}
        ${lib.strings.fileContents ./lua/others/telescope-nvim.lua}
        ${lib.strings.fileContents ./lua/others/neotest.lua}
        ${lib.strings.fileContents ./lua/others/which_key.lua}
        ${lib.strings.fileContents ./lua/ui/ui.lua}
        ${lib.strings.fileContents ./lua/ui/animate.lua}
        ${lib.strings.fileContents ./lua/ui/trouble.lua}
        ${lib.strings.fileContents ./lua/ui/gitsigns.lua}
        ${lib.strings.fileContents ./lua/ui/lualine.lua}
        ${lib.strings.fileContents ./lua/ui/bufferline.lua}
        ${lib.strings.fileContents ./lua/ui/tree.lua}
        ${lib.strings.fileContents ./lua/ui/neogit.lua}
        ${lib.strings.fileContents ./lua/ui/noice.lua}
        ${lib.strings.fileContents ./lua/cmp/cmp.lua}
        ${lib.strings.fileContents ./lua/lsp/lsp.lua}
        ${lib.strings.fileContents ./lua/lsp/lspsaga.lua}
        ${lib.strings.fileContents ./lua/dap/dap.lua}
        ${lib.strings.fileContents ./lua/dap/dapui.lua}
        ${lib.strings.fileContents ./lua/dap/dap_csharp.lua}
        ${lib.strings.fileContents ./lua/others/copy-paste.lua}
        EOF
      ''
    ];

    extraPackages = with pkgs; [
      xclip

      tree-sitter
      jq
      curl

      telescope
      bat
      ripgrep
      fd

      zathura
      xdotool

      unstable.vectorcode

      # extra language servers
      #rnix-lsp TODO fix slow closing time of neovim
      nodePackages.typescript
      nodePackages.typescript-language-server
      gopls
      texlab
      pyright
      rust-analyzer

      lldb
      vscode-extensions.vadimcn.vscode-lldb
      netcoredbg
      gcc
      texliveSmall
    ];

    plugins = with pkgs.vimPlugins; [
      # UI
      nvim-colorizer-lua
      nvim-web-devicons
      lsp-colors-nvim
      trouble-nvim
      lspsaga-nvim
      todo-comments-nvim
      lualine-nvim
      nvim-tree-lua
      bufferline-nvim
      nui-nvim
      nvim-notify
      rustaceanvim

      # Navigation
      nvim-treesitter
      nvim-treesitter.withAllGrammars
      telescope-nvim
      which-key-nvim
      vim-eunuch

      # Git
      gitsigns-nvim
      vim-fugitive
      neogit
      # vim-gitgutter

      # LSP
      nvim-lspconfig
      nvim-jdtls

      # DAP
      nvim-dap
      nvim-dap-ui
      nvim-dap-virtual-text
      telescope-dap-nvim

      # Theme
      nightfox-nvim
      tokyonight-nvim
      tender-vim
      sonokai
      catppuccin-nvim

      # Completion
      nvim-cmp
      cmp-git
      cmp-nvim-lsp
      cmp-nvim-lua
      cmp-nvim-lsp-signature-help
      cmp-path
      cmp-buffer
      cmp_luasnip
      cmp-cmdline

      # Tests
      nvim-test
      plenary-nvim
      neotest-plenary
      FixCursorHold-nvim
      neotest
      neotest-dotnet
      # neotest-rust

      # Ai
      codecompanion-nvim
      vectorcode-nvim

      # Others
      noice-nvim
      mini-animate
      nix-develop-nvim
      toggleterm-nvim
      markdown-preview-nvim
      # glow-nvim
      # ultisnips
      luasnip
      vimtex
      neoformat
      vim-addon-nix
      vim-toml
      # vim-clang-format
    ];
  };
}
