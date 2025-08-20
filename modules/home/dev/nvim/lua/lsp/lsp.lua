local servers = { 'ts_ls', "clangd", "jdtls", "pyright", "omnisharp", "texlab", 'volar' }
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

local on_attach = function(client, bufnr)
    vim.api.nvim_exec_autocmds('User', {pattern = 'LspAttached'})
    vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if client.server_capabilities.inlayHintProvider then
                vim.lsp.inlay_hint.enable(args.buf, true)
            end
            -- whatever other lsp config you want
        end
    })
end

for _, lsp in pairs(servers) do
    require('lspconfig')[lsp].setup({
        on_attach = on_attach,
        capabilities = capabilities,
    })
end

require("mason-lspconfig").setup {
    -- ensure_installed = servers,
}
