{
  flake,
  pkgs,
  config,
  ...
}: let
  unstablePkgs = flake.inputs.nixos-unstable.legacyPackages.${pkgs.system};
in {
  extraPlugins = with unstablePkgs.vimPlugins; [
    vectorcode-nvim
  ];

  extraConfigLua = ''
    require('vectorcode').setup({})
  '';
  plugins.codecompanion = {
    enable = true;
    package = unstablePkgs.vimPlugins.codecompanion-nvim;

    settings = {
      strategies = {
        chat.adapter = "gemini_cli";
        inline.adapter = "gemini_cli";
        cmd.adapter = "gemini_cli";
      };

      opts = {log_level = "DEBUG";};

      adapters = {
        http = {
          odeepseek = {
            __raw = ''
              function()
                return require("codecompanion.adapters").extend("ollama", {
                  name = "odeepseek",
                  schema = {
                    model = { default = "deepseek-r1:latest" },
                    num_ctx = { default = 16384 },
                    num_predict = { default = -1 },
                  },
                })
              end
            '';
          };
          ollama3 = {
            __raw = ''
              function()
                return require("codecompanion.adapters").extend("ollama", {
                  name = "ollama3.2",
                  schema = {
                    model = { default = "llama3.2:latest" },
                    num_ctx = { default = 16384 },
                    num_predict = { default = -1 },
                  },
                })
              end
            '';
          };
          oqwen3 = {
            __raw = ''
              function()
                return require("codecompanion.adapters").extend("ollama", {
                  name = "oqwen3-coder",
                  schema = {
                    model = { default = "qwen3-coder:latest" },
                    num_ctx = { default = 16384 },
                    num_predict = { default = -1 },
                  },
                })
              end
            '';
          };
          ogptoss = {
            __raw = ''
              function()
                return require("codecompanion.adapters").extend("ollama", {
                  name = "ogptoss",
                  schema = {
                    model = { default = "gpt-oss:latest" },
                    num_ctx = { default = 131072 },
                    num_predict = { default = -1 },
                  },
                })
              end
            '';
          };
        };
        acp = {
          gemini_cli = {
            __raw = ''
              function()
                return require("codecompanion.adapters").extend("gemini_cli", {
                  default = {
                    auth_method = "oauth-personal",
                  },
                })
              end
            '';
          };
        };
      };
      prompt_library = {
        "Generate Conventional Commit Message" = {
          strategy = "chat";
          description = "Generate a conventional commit message from staged diff";
          opts = {
            index = 1;
            is_default = true;
            is_slash_cmd = true;
            short_name = "commit";
            auto_submit = true;
          };
          prompts = [
            {
              role = "user";
              content = {
                __raw = ''
                  function()
                    local fmt = string.format
                    local commit_log = vim.fn.system('git log --pretty=format:"%s" -n 20')
                    local staged_diff = vim.fn.system("git diff --no-ext-diff --staged")
                    local prompt_template = [[
                      You are an expert commit message generator adhering strictly to the Conventional Commits 1.0.0 specification.

                      RULES:
                      1. Format: `<type>(<scope>): <subject>\n\n<body>`
                      2. Types: build, chore, ci, docs, feat, fix, perf, refactor, revert, style, test.
                      3. Subject: Lowercase, no period at end.

                      CONTEXT:
                      **Recent History:**
                      %s

                      **Staged Diff:**
                      %s

                      Please generate the commit message:
                    ]]
                    return fmt(prompt_template, commit_log, staged_diff)
                  end
                '';
              };
              opts.contains_code = true;
            }
          ];
        };
      };
      extensions = {
        vectorcode = {
          opts = {
            tool_group = {
              enabled = true;
              extras = ["file_search"];
              collapse = false;
            };
            tool_opts = {
              "*" = {};
              ls = {};
              vectorise = {};
              query = {
                max_num = {
                  chunk = -1;
                  document = -1;
                };
                default_num = {
                  chunk = 50;
                  document = 10;
                };
                include_stderr = false;
                use_lsp = true;
                no_duplicate = true;
                chunk_mode = false;
                summarise = {
                  enabled = false;
                  adapter = null;
                  query_augmented = true;
                };
              };
              files_ls = {};
              files_rm = {};
            };
          };
        };
      };
    };
  };
}
