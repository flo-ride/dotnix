{
  plugins.telescope = {
    enable = true;

    # These settings map directly to your 'defaults' table
    settings.defaults = {
      prompt_prefix = "» ";
      selection_caret = "» ";
      entry_prefix = "  ";

      layout_strategy = "horizontal";
      layout_config = {
        horizontal.mirror = false;
        vertical.mirror = false;
      };

      file_ignore_patterns = [
        "^.git/"
        "^.cache/"
        "%.o$"
        "%.a$"
        "%.out$"
        "%.class$"
        "%.pdf$"
        "%.mkv$"
        "%.mp4$"
        "%.zip$"
        "compile_commands.json"
        "target/"
        "node_modules/"
        "%.lock$"
      ];

      # Border characters (matches your Lua table)
      borderchars = ["─" "│" "─" "│" "╭" "╮" "╯" "╰"];
    };
  };
}
