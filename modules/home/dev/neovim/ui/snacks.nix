{
  plugins.snacks = {
    enable = true;

    settings = {
      bigfile.enabled = true;
      bufdelete.enabled = true;
      input.enabled = true;

      indent = {
        enabled = true;
        scope.enabled = false;
      };

      image = {
        enabled = true;
        # img_dirs = ["~/Documents/Screenshots/"];
      };

      dashboard = {
        enabled = true;
        preset.keys = [
          {
            icon = " ";
            key = "l";
            desc = "Load Session";
            action = ":lua require('persisted').load()";
          }
          {
            icon = " ";
            key = "n";
            desc = "New File";
            action = ":ene | startinsert";
          }
          {
            icon = " ";
            key = "r";
            desc = "Recent Files";
            action = ":lua Snacks.dashboard.pick('oldfiles')";
          }
          {
            icon = " ";
            key = "f";
            desc = "Find File";
            action = ":lua Snacks.dashboard.pick('files')";
          }
          {
            icon = "󱘣 ";
            key = "s";
            desc = "Search Files";
            action = ":lua Snacks.dashboard.pick('live_grep')";
          }
          {
            icon = " ";
            key = "q";
            desc = "Quit";
            action = ":qa";
          }
        ];
        sections = [
          {section = "startup";}
        ];
      };

      picker = {
        enabled = true;
        prompt = "> ";
        win = {
          input.wo.foldcolumn = "0";
          list.wo.foldcolumn = "0";
          preview.wo.foldcolumn = "0";
          input.keys = {
            "<C-q>" = ["qflist_append" {mode = ["n" "i"];}];
          };
        };
        actions = {
          # Use __raw to pass the Lua function directly
          qflist_append.__raw = ''
            function(picker)
              picker:close()
              local sel = picker:selected()
              local items = #sel > 0 and sel or picker:items()
              local qf = {}
              for _, item in ipairs(items) do
                qf[#qf + 1] = {
                  filename = Snacks.picker.util.path(item),
                  bufnr = item.buf,
                  lnum = item.pos and item.pos[1] or 1,
                  col = item.pos and item.pos[2] + 1 or 1,
                  end_lnum = item.end_pos and item.end_pos[1] or nil,
                  end_col = item.end_pos and item.end_pos[2] + 1 or nil,
                  text = item.line or item.comment or item.label or item.name or item.detail or item.text,
                  pattern = item.search,
                  valid = true,
                }
              end
              vim.fn.setqflist(qf, "a")
              vim.cmd("botright copen")
            end
          '';
        };
      };
    };
  };
}
