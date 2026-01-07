{
  plugins.neotest = {
    enable = true;

    # Adapters
    adapters = {
      plenary.enable = true;
      dotnet.enable = true;
      rust.enable = true;
    };

    # Icons & UI logic
    settings = {
      icons = {
        child_indent = "";
        child_prefix = "";
        collapsed = "";
        expanded = "";
        failed = "";
        final_child_prefix = "";
        non_collapsible = "";
        passed = "";
        running = "";
        unknown = "";
      };

      # Optional: Summary window settings to match your UI style
      summary = {
        mappings = {
          expand = [ "<CR>" "o" ];
          stop = "u";
        };
      };
    };
  };
}
