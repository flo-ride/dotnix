{
  plugins.which-key = {
    enable = true;

    settings = {win = {border = "rounded";};};

    settings.spec = [
      # --- Mappings  ---
      {
        __unkeyed-1 = "Y";
        __unkeyed-2 = "y$";
        desc = "Yank to end of line";
      }
      {
        __unkeyed-1 = ";";
        __unkeyed-2 = ":";
        desc = "Enter Command Mode";
      }

      # Window Management
      {
        __unkeyed-1 = "+";
        __unkeyed-2 = "<C-W>+";
        desc = "Increase Height";
      }
      {
        __unkeyed-1 = "_";
        __unkeyed-2 = "<C-W>-";
        desc = "Decrease Height";
      }
      {
        __unkeyed-1 = "<M-.>";
        __unkeyed-2 = "<C-W><";
        desc = "Decrease Width";
      }
      {
        __unkeyed-1 = "<M-,>";
        __unkeyed-2 = "<C-W>>";
        desc = "Increase Width";
      }

      # Git / Merge (Fugitive style)
      {
        __unkeyed-1 = "<leader>h";
        group = "Git Hydration/Merge";
      }
      {
        __unkeyed-1 = "<leader>hl";
        __unkeyed-2 = "<cmd>Gvdiffsplit!<cr>";
        desc = "Git Merge Diff";
      }
      {
        __unkeyed-1 = "<C-h>";
        __unkeyed-2 = "<cmd>diffget //2<cr>";
        desc = "Diff Get Left (Local)";
      }
      {
        __unkeyed-1 = "<C-l>";
        __unkeyed-2 = "<cmd>diffget //3<cr>";
        desc = "Diff Get Right (Remote)";
      }

      # Tabs
      {
        __unkeyed-1 = "<A-1>";
        __unkeyed-2 = "1gt";
        desc = "Move to Tab 1";
      }
      {
        __unkeyed-1 = "<A-2>";
        __unkeyed-2 = "2gt";
        desc = "Move to Tab 2";
      }
      {
        __unkeyed-1 = "<A-3>";
        __unkeyed-2 = "3gt";
        desc = "Move to Tab 3";
      }
      {
        __unkeyed-1 = "<A-4>";
        __unkeyed-2 = "4gt";
        desc = "Move to Tab 4";
      }
      {
        __unkeyed-1 = "<A-5>";
        __unkeyed-2 = "5gt";
        desc = "Move to Tab 5";
      }
      {
        __unkeyed-1 = "<A-6>";
        __unkeyed-2 = "6gt";
        desc = "Move to Tab 6";
      }
      {
        __unkeyed-1 = "<A-7>";
        __unkeyed-2 = "7gt";
        desc = "Move to Tab 7";
      }
      {
        __unkeyed-1 = "<A-8>";
        __unkeyed-2 = "8gt";
        desc = "Move to Tab 8";
      }
      {
        __unkeyed-1 = "<A-9>";
        __unkeyed-2 = "9gt";
        desc = "Move to Tab 9";
      }

      {
        __unkeyed-1 = "<A-t>";
        __unkeyed-2 = "<cmd>tabnew<cr>";
        desc = "Create a new Tab";
      }
      {
        __unkeyed-1 = "<A-h>";
        __unkeyed-2 = "<cmd>tabprevious<cr>";
        desc = "Move to the previous Tab";
      }
      {
        __unkeyed-1 = "<A-l>";
        __unkeyed-2 = "<cmd>tabnext<cr>";
        desc = "Move to the next Tab";
      }
      {
        __unkeyed-1 = "<A-w>";
        __unkeyed-2 = "<cmd>tabclose<cr>";
        desc = "Close the current Tab";
      }

      # Search & UI
      {
        __unkeyed-1 = "<C-f>";
        __unkeyed-2 = "<cmd>lua Snacks.picker.lines()<cr>";
        desc = "Find Text in Current Buffer";
      }
      {
        __unkeyed-1 = "K";
        __unkeyed-2 = "<cmd>Lspsaga hover_doc<cr>";
        desc = "Show doc of hover";
      }
      {
        __unkeyed-1 = "<F2>";
        __unkeyed-2 = "<cmd>NvimTreeToggle<cr>";
        desc = "Open Tree";
      }
      {
        __unkeyed-1 = "fg";
        __unkeyed-2 = "<cmd>Neogit<cr>";
        desc = "NeoGit";
      }

      # Space Group
      {
        __unkeyed-1 = "<space>";
        group = "<Space>";
      }
      {
        __unkeyed-1 = "<space><space>";
        __unkeyed-2 = "<cmd>Trouble diagnostics toggle<cr>";
        desc = "Trouble Toggle";
      }
      {
        __unkeyed-1 = "<space>d";
        __unkeyed-2 = "<cmd>Lspsaga peek_definition<cr>";
        desc = "Show Definition";
      }
      {
        __unkeyed-1 = "<space>D";
        __unkeyed-2 = "<cmd>Lspsaga goto_definition<cr>";
        desc = "Show Definition";
      }
      {
        __unkeyed-1 = "<space>f";
        __unkeyed-2 = "<cmd>Lspsaga code_action<cr>";
        desc = "Code Action";
      }
      {
        __unkeyed-1 = "<space>i";
        __unkeyed-2 = "<cmd>Lspsaga finder<cr>";
        desc = "Show Implementation";
      }
      {
        __unkeyed-1 = "<space>r";
        __unkeyed-2 = "<cmd>Lspsaga rename<cr>";
        desc = "Rename";
      }
      {
        __unkeyed-1 = "<space>a";
        __unkeyed-2 = "<cmd>CodeCompanionActions<cr>";
        desc = "AI Actions";
      }

      # Leader Group
      {
        __unkeyed-1 = "<leader>";
        group = "<Leader>";
      }

      # Snacks
      {
        __unkeyed-1 = "<leader>f";
        group = "Snacks";
      }
      {
        __unkeyed-1 = "<leader>ff";
        __unkeyed-2 = "<cmd>lua Snacks.picker.files({ hidden = true })<cr>";
        desc = "Find File";
      }
      {
        __unkeyed-1 = "<leader>fg";
        __unkeyed-2 = "<cmd>lua Snacks.picker.grep()<cr>";
        desc = "Find Text in Workspace";
      }
      {
        __unkeyed-1 = "<leader>fo";
        __unkeyed-2 = "<cmd>Telescope oldfiles<cr>";
        desc = "Open Recent File";
      }
      {
        __unkeyed-1 = "<leader>fr";
        __unkeyed-2 = "<cmd>Telescope resume<cr>";
        desc = "Resume Last Search";
      }
      {
        __unkeyed-1 = "<leader>ft";
        __unkeyed-2 = "<cmd>TodoTelescope<cr>";
        desc = "Find Todo's";
      }

      # NeoTest
      {
        __unkeyed-1 = "<leader>t";
        group = "NeoTest";
      }
      {
        __unkeyed-1 = "<leader>tf";
        __unkeyed-2 = "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>";
        desc = "Launch file";
      }
      {
        __unkeyed-1 = "<leader>th";
        __unkeyed-2 = "<cmd>lua require('neotest').run.run()<cr>";
        desc = "Launch hover test";
      }
      {
        __unkeyed-1 = "<leader>tt";
        __unkeyed-2 = "<cmd>lua require('neotest').summary.toggle()<cr>";
        desc = "Toggle NeoTest";
      }

      # DAP (Debugger)
      {
        __unkeyed-1 = "<F5>";
        __unkeyed-2 = "<cmd>lua require('dap').continue()<cr>";
        desc = "DAP Continue / Start";
      }
      {
        __unkeyed-1 = "<F3>";
        __unkeyed-2 = "<cmd>lua require('dap').terminate()<cr>";
        desc = "DAP Stop";
      }
      {
        __unkeyed-1 = "<F4>";
        __unkeyed-2 = "<cmd>lua require('dap').restart()<cr>";
        desc = "DAP Restart";
      }
      {
        __unkeyed-1 = "<S-F5>";
        __unkeyed-2 = "<cmd>lua require('dap').run_last()<cr>";
        desc = "DAP Run Last";
      }
      {
        __unkeyed-1 = "<F8>";
        __unkeyed-2 = "<cmd>lua require('dap').toggle_breakpoint()<cr>";
        desc = "DAP Toggle Breakpoint";
      }
      {
        __unkeyed-1 = "<F10>";
        __unkeyed-2 = "<cmd>lua require('dap').step_over()<cr>";
        desc = "DAP Step Over";
      }
      {
        __unkeyed-1 = "<F11>";
        __unkeyed-2 = "<cmd>lua require('dap').step_into()<cr>";
        desc = "DAP Step Into";
      }
      {
        __unkeyed-1 = "<S-F11>";
        __unkeyed-2 = "<cmd>lua require('dap').step_out()<cr>";
        desc = "DAP Step Out";
      }

      # ToggleTerm
      {
        __unkeyed-1 = "<A-CR>";
        __unkeyed-2 = "<cmd>ToggleTerm direction=float<cr>";
        desc = "Toggle Floating Term";
      }
      {
        __unkeyed-1 = "<A-CR>";
        __unkeyed-2 = "<cmd>ToggleTerm direction=float<cr>";
        desc = "Toggle Floating Term";
        mode = "t";
      }
    ];
  };

  # Mappings for blink.cmp
  plugins.blink-cmp.settings.keymap = {
    preset = "enter";
    "<C-space>" = ["show" "show_documentation" "hide_documentation"];
  };

  # Mappings that don't fit well in Which-Key (Insert/Terminal/Command mode)
  keymaps = [
    {
      mode = "i";
      key = "<C-w>";
      action = "<C-o><C-w>";
      options.desc = "Switch windows from Insert mode";
    }
    {
      mode = "t";
      key = "<Esc>";
      action = "<C-\\><C-n>";
      options.desc = "Escape terminal mode";
    }
  ];

  # Command line abbreviations (the sudo write trick)
  extraConfigVim = ''
    cnoreabbrev w!! w !sudo tee % >/dev/null
  '';
}
