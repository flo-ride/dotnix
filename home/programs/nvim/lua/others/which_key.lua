local which_key = require('which-key')

local setup = {
    win = {
        border = "rounded",
    },
}

which_key.setup(setup)

local keymaps = {
    { "<A-1>", "1gt", desc = "Move to Tab 1", nowait = true, remap = false },
    { "<A-2>", "2gt", desc = "Move to Tab 2", nowait = true, remap = false },
    { "<A-3>", "3gt", desc = "Move to Tab 3", nowait = true, remap = false },
    { "<A-4>", "4gt", desc = "Move to Tab 4", nowait = true, remap = false },
    { "<A-5>", "5gt", desc = "Move to Tab 5", nowait = true, remap = false },
    { "<A-6>", "6gt", desc = "Move to Tab 6", nowait = true, remap = false },
    { "<A-7>", "7gt", desc = "Move to Tab 7", nowait = true, remap = false },
    { "<A-8>", "8gt", desc = "Move to Tab 8", nowait = true, remap = false },
    { "<A-9>", "9gt", desc = "Move to Tab 9", nowait = true, remap = false },

    { "<A-t>", "<cmd>:tabnew<cr>", desc = "Create a new Tab", nowait = true, remap = false },
    { "<A-h>", "<cmd>:tabprevious<cr>", desc = "Move to the previous Tab", nowait = true, remap = false },
    { "<A-l>", "<cmd>:tabnext<cr>", desc = "Move to the next Tab", nowait = true, remap = false },
    { "<A-w>", "<cmd>:tabclose<cr>", desc = "Close the current Tab", nowait = true, remap = false },

    { "<C-f>", "<cmd>:Telescope current_buffer_fuzzy_find<cr>", desc = "Find Text in Current Buffer", nowait = true, remap = false },

    { "K", "<cmd>:Lspsaga hover_doc<cr>", desc = "Show doc of hover", nowait = true, remap = false },

    { "<space>", group = "Lsp", nowait = true, remap = false },
    { "<space><space>", "<cmd>Trouble diagnostics toggle<cr>", desc = "Trouble Toggle", nowait = true, remap = false },
    { "<space>d", "<cmd>Lspsaga peek_definition<cr>", desc = "Show Definition", nowait = true, remap = false },
    { "<space>D", "<cmd>Lspsaga goto_definition<cr>", desc = "Show Definition", nowait = true, remap = false },
    { "<space>f", "<cmd>Lspsaga code_action<cr>", desc = "Code Action", nowait = true, remap = false },
    { "<space>i", "<cmd>Lspsaga finder<cr>", desc = "Show Implementation", nowait = true, remap = false },
    { "<space>r", "<cmd>Lspsaga rename<cr>", desc = "Rename", nowait = true, remap = false },

    { "<leader>", group = "<Leader>", nowait = true, remap = false },
    { "<leader>f", group = "Telescope", nowait = true, remap = false },
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Switch Buffer", nowait = true, remap = false },
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find File", nowait = true, remap = false },
    { "<leader>fd", "<cmd>NvimTreeToggle<cr>", desc = "Open Tree", nowait = true, remap = false },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Find Text in Workspace", nowait = true, remap = false },
    { "<leader>fo", "<cmd>Telescope oldfiles<cr>", desc = "Open Recent File", nowait = true, remap = false },
    { "<leader>fr", "<cmd>Telescope resume<cr>", desc = "Resume Last Search", nowait = true, remap = false },
    { "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "Find Todo's", nowait = true, remap = false },
    { "<leader>t", group = "NeoTest", nowait = true, remap = false },
    { "<leader>tf", "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", desc = "Launch file", nowait = true, remap = false },
    { "<leader>th", "<cmd>lua require('neotest').run.run()<cr>", desc = "Launch hover test", nowait = true, remap = false },
    { "<leader>tt", "<cmd>lua require('neotest').summary.toggle()<cr>", desc = "Toggle NeoTest", nowait = true, remap = false },

    -- Dap
    { "<F5>", "<cmd>lua require('dap').continue()<cr>", desc = "DAP Continue / Start", nowait = true, remap = false },
    { "<F3>", "<cmd>lua require('dap').terminate()<cr>", desc = "DAP Stop", nowait = true, remap = false },
    { "<F4>", "<cmd>lua require('dap').restart()<cr>", desc = "DAP Restart", nowait = true, remap = false },
    { "<S-F5>", "<cmd>lua require('dap').run_last()<cr>", desc = "DAP Run Last", nowait = true, remap = false },
    { "<F8>", "<cmd>lua require('dap').toggle_breakpoint()<cr>", desc = "DAP Toggle Breakpoint", nowait = true, remap = false },
    { "<F10>", "<cmd>lua require('dap').step_over()<cr>", desc = "DAP Step Over", nowait = true, remap = false },
    { "<F11>", "<cmd>lua require('dap').step_into()<cr>", desc = "DAP Step Into", nowait = true, remap = false },
    { "<S-F11>", "<cmd>lua require('dap').step_out()<cr>", desc = "DAP Step Out", nowait = true, remap = false },

    { "<A-CR>", "<cmd>ToggleTerm direction=float<cr>", desc = "Toggle Floating Term", nowait = true, remap = false },
    { "<A-CR>", "<cmd>ToggleTerm direction=float<cr>", desc = "Toggle Floating Term", mode = "t", nowait = true, remap = false },
}

which_key.add(keymaps)
