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
      server = {
        default_settings = {
          rust-analyzer = {
            cargo = {
              allFeatures = true;
            };
            check = {
              command = "clippy"; # Use clippy instead of cargo check
            };
          };
        };
      };
    };
  };
}
