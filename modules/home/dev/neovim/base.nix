{
  colorschemes.catppuccin.enable = true;

  diagnostic = {
    settings = {
      virtual_text = false;
      virtual_lines.current_line = true;

      signs = {
        text = {
          "__raw" = ''
            {
              [vim.diagnostic.severity.ERROR] = "",
              [vim.diagnostic.severity.WARN]  = "",
              [vim.diagnostic.severity.INFO]  = "",
              [vim.diagnostic.severity.HINT]  = "󰌵",
            }
          '';
        };
      };
      underline = true;
      update_in_insert = false;
      severity_sort = true;
    };
  };

  opts = {
    # --- UI & Behavior ---
    # Coc/LSP Recommended stability settings
    backup = false;
    writebackup = false;
    updatetime = 300;
    cmdheight = 1;

    # Display & Whiteboard
    number = true;
    cursorline = true;
    scrolloff = 5;
    showmatch = true;
    wrap = true;

    # Listchars (Whitespace)
    list = true;
    listchars = "tab:>─,eol:¬,trail: ,nbsp:¤";
    fillchars = "vert:│";

    # Command Line Completion
    # We keep this because your 'longest:full' is a specific preference
    wildmode = "longest:full,list:full";

    # --- Search ---
    ignorecase = true;
    smartcase = true;
    hlsearch = false;

    # --- Indentation ---
    tabstop = 4;
    shiftwidth = 4;
    softtabstop = -1;
    expandtab = true;
    smartindent = true;
  };

  # Custom Autocommands (Doxygen/Latex)
  autoCmd = [
    {
      event = ["BufRead" "BufNewFile"];
      pattern = ["*.h"];
      command = "set filetype=c.doxygen";
    }
    {
      event = ["BufRead" "BufNewFile"];
      pattern = ["*.tex"];
      command = "set filetype=latex";
    }
  ];
}
