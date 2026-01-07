{
  plugins.lualine = {
    enable = true;
    settings = {
      options = {
        theme = "auto";
        icons_enabled = true;
        component_separators = "|";
        section_separators = {
          left = " ";
          right = " ";
        };
        disabled_filetypes = ["NvimTree" "DiffviewFilePanel" "DiffviewFileHistory"];
      };

      sections = {
        lualine_a = ["mode"];
        lualine_b = ["branch" "diff"];
        lualine_c = ["filename"];
        lualine_x = [
          {
            __unkeyed-1 = "diagnostics";
            sources = ["nvim_diagnostic"];
            symbols = {
              debug = " ";
              error = " ";
              info = " ";
              trace = "✎ ";
              warn = " ";
            };
          }
        ];
        lualine_y = [
          {
            __unkeyed-1 = "filetype";
            colored = true;
            icon_only = true;
            icon = "❄ ❅ ❆";
          }
          "encoding"
          {
            __unkeyed-1 = "fileformat";
            symbols = {
              unix = "";
              dos = "";
              mac = "";
            };
          }
        ];
        lualine_z = ["progress" "location"];
      };

      inactive_sections = {
        lualine_a = [];
        lualine_b = [];
        lualine_c = ["filename"];
        lualine_x = ["location"];
        lualine_y = [];
        lualine_z = [];
      };

      extensions = ["quickfix" "nvim-tree" "nvim-dap-ui" "toggleterm" "fugitive"];
    };
  };
}
