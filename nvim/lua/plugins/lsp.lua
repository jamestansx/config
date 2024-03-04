local function remove_docs(docs)
    if docs then
        for i = 1, #docs.signatures do
            if docs.signatures[i] and docs.signatures[i].documentation then
                if docs.signatures[i].documentation.value then
                    docs.signatures[i].documentation.value = nil
                else
                    docs.signatures[i].documentation = nil
                end
            end
        end
    end
    return docs
end

_G.create_autocmd("LspAttach", {
    group = "LspInit",
    callback = function(ev)
        local bufnr = ev.buf

        vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

        vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
        vim.keymap.set("n", "gD", vim.lsp.buf.type_definition, { buffer = bufnr })
        vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr })
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr })
        vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
        vim.keymap.set({ "n", "i" }, "<C-k>", vim.lsp.buf.signature_help, { buffer = bufnr })
        vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, { buffer = bufnr })
        vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { buffer = bufnr })

        vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
            update_in_insert = true,
            severity_sort = true,
            virtual_text = { source = "if_many" },
        })

        vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(function(_, res, ctx, conf)
            return vim.lsp.handlers.signature_help(_, remove_docs(res), ctx, conf)
        end, { anchor_bias = "above" })
    end,
})

return {
    {
        "neovim/nvim-lspconfig",
        event = {
            "BufReadPost",
            "BufNewFile",
        },
        config = function()
            local lspconfig = require("lspconfig")

            -- Add LSP here
        end,
    },
}
