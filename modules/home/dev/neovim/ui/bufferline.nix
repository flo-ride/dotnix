{
  plugins.bufferline = {
    enable = true;
    settings.options = {
      mode = "tabs";
      separator_style = "slant";
      diagnostics = "nvim_lsp";

      # We use a raw Lua string to port your custom diagnostic icons
      diagnostics_indicator = ''
        function(count, level, diagnostics_dict, context)
          local icon = level:match("error") and " " or " "
          return " " .. icon .. count
        end
      '';

      offsets = [
        {
          filetype = "NvimTree";
          text = "File Explorer";
          highlight = "Directory";
          separator = true;
        }
      ];
    };
  };
}
