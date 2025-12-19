local capabilities = require('cmp_nvim_lsp').default_capabilities()


vim.lsp.config('*', {
    root_markers = { '.git' },
    capabilities = capabilities
})


local servers = { 'ts_ls', "clangd", "jdtls", "pyright", "omnisharp", "texlab" }
for _, lsp in pairs(servers) do
    vim.lsp.enable(lsp)
end
