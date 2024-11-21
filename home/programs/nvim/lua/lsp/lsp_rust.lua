require'lspconfig'.rust_analyzer.setup {
    settings = {                      
        ["rust-analyzer"] = {
            diagnostics = {
                enable = true,
                disabled = {"unresolved-proc-macro"},
                enableExperimental = true,
            },
        }
    }
}
