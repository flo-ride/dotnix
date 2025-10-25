require("codecompanion").setup({
    strategies = {
        chat = {
            adapter = "gemini",
        },
        inline = {
            adapter = "gemini",
        },
        cmd = {
            adapter = "gemini",
        }
    },
    opts = {
        log_level = "DEBUG", -- TRACE|DEBUG|ERROR|INFO
    },
    adapters = {
        acp = {
            opts = {
                show_defaults = false,
            },
        },
        http = {
            opts = {
                show_defaults = false,
            },
        },
        llama3 = function()
            return require("codecompanion.adapters").extend("ollama", {
                name = "llama3.2",
                schema = {
                    model = {
                        default = "llama3.2:latest",
                    },
                    num_ctx = {
                        default = 16384,
                    },
                    num_predict = {
                        default = -1,
                    },
                },
            })
        end,
    },
    prompt_library = {
        ["Generate a Commit Message 1.0"] = {
            strategy = "chat",
            description = "Generate a conventional commit message from staged diff",
            opts = {
                -- These are from your example and are great for usability
                index = 10,
                is_default = true,
                is_slash_cmd = true,
                short_name = "commit",
                auto_submit = true,
            },
            prompts = {
                {
                    role = "user", -- 'constants.USER_ROLE' is just "user"
                    content = function()
                        -- Use local 'string.format' for a self-contained snippet
                        local fmt = string.format

                        -- 1. Get the last 20 commit message subjects for history/context
                        local commit_log = vim.fn.system('git log --pretty=format:"%s" -n 20')

                        -- 2. Get the staged diff
                        local staged_diff = vim.fn.system("git diff --no-ext-diff --staged")

                        -- 3. Define the master prompt template
                        local prompt_template = [[You are an expert commit message generator adhering strictly to the Conventional Commits 1.0.0 specification.

Your task is to generate a commit message based on the staged 'git diff' and the project's recent commit history.

RULES:
1.  The commit message must follow this format: `<type>(<scope>): <subject>\n\n<body>`
2.  **Type:** You MUST use one of the following types: `build`, `chore`, `ci`, `docs`, `feat`, `fix`, `perf`, `refactor`, `revert`, `style`, `test`.
3.  **Scope (Optional):** If possible, infer a relevant, lowercase scope from the diff (e.g., a module, component, or file area like 'parser', 'api', 'deps'). If no clear scope applies, omit it.
4.  **Subject:** A concise description of the change. Start with a lowercase letter. Do not end with a period.
5.  **Body (Optional):** After a blank line, provide a brief explanation of the 'what' and 'why' of the change. Wrap lines at 72 characters. Omit the body for trivial changes (e.g., `style`, `chore`).
6.  **Output:** Return ONLY the raw commit message (subject and body). Do NOT include markdown codeblocks (```) or any other explanatory text or conversation.

CONTEXT:

**Recent Commit History (for style consistency):**
````

%s

````

**Staged Git Diff:**
```diff
%s
````

Please generate the commit message:
]]

                        -- Return the formatted prompt
                        return fmt(prompt_template, commit_log, staged_diff)
                    end,
                    opts = {
                        contains_code = true, -- This is crucial for sending the diff
                    },
                },
            },
        },
    },
})
