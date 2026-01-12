{
  plugins.blink-cmp = {
    enable = true;
    settings = {
      appearance.use_nvim_cmp_as_default = true;

      sources = {default = ["lsp" "path" "snippets" "buffer" "codecompanion"];};
      signature.enabled = true;

      completion = {
        menu.border = "single";
        documentation = {
          auto_show = true;
          window.border = "single";
        };
      };
    };
  };
}
