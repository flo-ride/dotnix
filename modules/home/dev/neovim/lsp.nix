{
  plugins.lsp = {
    enable = true;

    servers = {
      # TypeScript / JavaScript
      ts_ls.enable = true;

      # C / C++
      clangd.enable = true;

      # Java
      jdtls.enable = true;

      # Python
      pyright.enable = true;

      # C# / .NET
      omnisharp.enable = true;

      # LaTeX
      texlab.enable = true;

      # Nix
      nixd.enable = true;
    };
  };

  plugins.rustaceanvim = {
    enable = true;
    settings = {
      tools.enable_clippy = true;
      server = {
        default_settings = {
          rust-analyzer = {
            cargo = {
              allFeatures = true;
              loadOutDirsFromCheck = true;
              buildScripts = {
                enable = true;
              };
            };
            procMacro = {
              enable = true;
              ignored = {
                leptos_macro = [
                  "server"
                ];
              };
            };
            check = {
              command = "clippy"; # Use clippy instead of cargo check
            };
            files = {
              excludeDirs = ["target" ".git" ".cargo" ".github" ".direnv"];
            };
          };
        };
      };
    };
  };
}
