{
  flake,
  pkgs,
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
          gemini_flash = {
            __raw = ''
              function()
                return require("codecompanion.adapters").extend("gemini_cli", {
                  name = "gemini_flash",
                  schema = {
                    model = {
                      default = "gemini-2.5-flash-lite",
                    },
                  },
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
        "Document Folder" = {
          strategy = "chat";
          description = "Document all files in a specific folder (Agentic)";
          opts = {
            index = 4;
            is_default = false;
            is_slash_cmd = true;
            alias = "docdir";
            auto_submit = true;
          };
          prompts = [
            {
              role = "user";
              content = {
                __raw = ''
                  function()
                    local folder_path = vim.fn.input("Folder to document (relative to root): ", "./src/")
                    if folder_path == "" then return nil end

                    return string.format(
                      "You are a technical documentation agent. I want you to document the entire folder at: `%s`\n\n" ..
                      "**Your Workflow:**\n" ..
                      "1. Use your `ls` or `files` tool to list all files in that directory.\n" ..
                      "2. For each relevant source file (skip lockfiles/binaries):\n" ..
                      "   - Read the file content.\n" ..
                      "   - Add language-appropriate doc-comments (/// for Rust, etc.).\n" ..
                      "   - Use your `edit_file` tool to save the changes.\n\n" ..
                      "Start by listing the files in `%s`.",
                      folder_path, folder_path
                    )
                  end
                '';
              };
              opts.contains_code = true;
            }
          ];
        };
        "Document Code File" = {
          strategy = "chat";
          description = "Ask the AI to document the current buffer using its editing tools";
          opts = {
            index = 3;
            is_default = false;
            is_slash_cmd = true;
            alias = "docs";
            auto_submit = true;
          };
          prompts = [
            {
              role = "user";
              content = {
                __raw = ''
                  function(context)
                    local ft = vim.bo.filetype
                    local full_path = vim.api.nvim_buf_get_name(context.bufnr)

                    local lang_rules = {
                      rust = "Use /// for items and //! for module headers. Document Panics and Errors.",
                      python = 'Use triple-quoted docstrings """ """ inside the function/class.',
                      lua = "Use --- LDoc style comments.",
                      javascript = "Use JSDoc /** */ style.",
                      typescript = "Use TSDoc /** */ style.",
                      go = "Use standard // comments starting with the name of the object.",
                      nix = "Use standard # comments."
                    }
                    local rule = lang_rules[ft] or ("Use the standard documentation convention for " .. ft)

                    return string.format(
                      "You are an agentic assistant. Please add documentation comments to the file at: %s\n\n" ..
                      "**Language Rules for %s:**\n%s\n\n" ..
                      "**Task:**\n" ..
                      "1. Read the code provided via the #buffer variable.\n" ..
                      "2. Use your `edit_file` tool to apply these comments directly to the file.\n" ..
                      "3. Ensure parameters and return types are documented.\n\n" ..
                      "Perform the file edit now.",
                      full_path, ft, rule
                    )
                  end
                '';
              };
              opts.contains_code = true;
            }
          ];
        };

        "Generate Merge Request Message" = {
          strategy = "chat";
          description = "Generate a MR description (Conventional Commits) with branch selection";
          opts = {
            index = 2;
            is_default = false;
            is_slash_cmd = true;
            alias = "mr";
            auto_submit = true;
          };

          prompts = [
            {
              role = "user";
              content = {
                __raw = ''
                  function()
                    local fmt = string.format

                    -- 1. Get the default branch (fallback to main)
                    local default_branch = vim.fn.system("git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@'"):gsub("%s+", "")
                    if default_branch == "" then default_branch = "main" end

                    -- 2. Prompt user for the base branch
                    local base_branch = vim.fn.input("Base branch (default: " .. default_branch .. "): ")
                    if base_branch == "" then base_branch = default_branch end


                    -- 3. Gather Git context
                    local diff = vim.fn.system(fmt("git diff %s...HEAD", base_branch))
                    local summary = vim.fn.system(fmt("git log %s..HEAD --oneline", base_branch))

                    local prompt_template = [[
                      You are an expert technical writer. Generate a Merge Request description.

                      STRICT RULES:
                      1. Use the Conventional Commits 1.0.0 specification for the summary line.
                      2. Output Format:
                         # <type>(<scope>): <subject>

                         ## Summary
                         (Briefly explain the 'why' behind these changes)

                         ## Changes
                         (Bullet points of technical changes)

                      CONTEXT:
                      **Base Branch:** %s
                      **Commits:**
                      %s

                      **Diff:**
                      %s
                    ]]
                    return fmt(prompt_template, base_branch, summary, diff)
                  end
                '';
              };
              opts.contains_code = true;
            }
          ];
        };

        "Generate Conventional Commit Message" = {
          strategy = "chat";
          description = "Generate a conventional commit message from staged diff";
          adapter = "gemini_flash";
          opts = {
            index = 1;
            is_default = true;
            is_slash_cmd = true;
            alias = "commit";
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
