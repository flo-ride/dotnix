{
  plugins.telescope = {
    enable = false;
    settings.defaults = {
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
    };
  };
}
