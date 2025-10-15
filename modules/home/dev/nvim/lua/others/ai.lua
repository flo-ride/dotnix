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
});
