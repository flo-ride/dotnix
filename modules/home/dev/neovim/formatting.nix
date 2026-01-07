{
  plugins.lsp-format.enable = true;
  plugins.none-ls = {
    enable = true;
    enableLspFormat = true;
    settings = {
      # Use your custom diagnostic icons
      diagnostics_format = "[#{c}] #{m} (#{s})";
    };

    sources = {
      formatting = {
        # Lua
        stylua.enable = true;
        # Nix
        nixfmt.enable = true;
        # Shell
        shfmt.enable = true;
        # Python
        black.enable = true;
        # Web (JS/TS/JSON/HTML/CSS)
        prettier = {
          enable = true;
          disableTsServerFormatter = true;
        };
        # C / C++ / C#
        clang_format.enable = true;
      };
    };
  };
}
