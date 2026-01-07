{
  plugins.dap.signs = {
    dapBreakpoint = {
      text = "";
      texthl = "DapBreakpoint";
    };
    dapBreakpointRejected = {
      text = "";
      texthl = "DapBreakpointRejected";
    };
    dapStopped = {
      text = "";
      texthl = "DapStopped";
    };
  };
  plugins.dap-virtual-text.enable = true;
  plugins.dap-ui = {
    enable = true;
    settings = {
      icons = {
        collapsed = "▸";
        expanded = "▾";
      };
      expand_lines = true;
      layouts = [
        {
          position = "left";
          size = 40;
          elements = [
            {
              id = "scopes";
              size = 0.25;
            }
            {
              id = "breakpoints";
              size = 0.25;
            }
            {
              id = "stacks";
              size = 0.25;
            }
            {
              id = "watches";
              size = 0.25;
            }
          ];
        }
        {
          position = "bottom";
          size = 10;
          elements = [ "repl" ];
        }
      ];
      mappings = {
        edit = "e";
        expand = [ "<CR>" "<2-LeftMouse>" ];
        open = "o";
        remove = "d";
        repl = "r";
        toggle = "t";
      };
      floating = {
        border = "single";
        mappings = { close = [ "q" "<Esc>" ]; };
      };
      windows.indent = 1;
    };
  };
}
