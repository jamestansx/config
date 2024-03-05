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

local function python_path()
    local util = require("lspconfig").util

    -- Env
    local env = vim.env.VIRTUAL_ENV
    if env then
        return util.path.join(env, "bin", "python")
    end

    -- Root pattern of pyvenv.cfg
    local homedir = vim.loop.os_homedir()
    local res = vim.fs.find("pyvenv.cfg", {
        path = util.root_pattern({
            ".git",
            "setup.py",
            "setup.cfg",
            "pyproject.toml",
            "requirements.txt",
            "Pipfile",
        })(util.path.sanitize(vim.api.nvim_buf_get_name(0), 0)),
        stop = homedir,
        upward = false,
    })[1]
    if res then
        return util.path.join(vim.fs.dirname(res), "bin", "python")
    end

    -- fallback
    return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
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
    {
        "j-hui/fidget.nvim",
        event = "LspAttach",
        opts = {
            progress = {
                display = {
                    render_limit = 5,
                },
            },
            notification = {
                window = {
                    winblend = 0,
                },
            },
        },
    },
    {
        "stevearc/conform.nvim",
        cmd = {
            "ConformInfo",
        },
        keys = {
            {
                "<leader>f",
                function()
                    require("conform").format({
                        async = false,
                        lsp_fallback = true,
                    })
                end,
                mode = { "n", "x" },
            },
        },
        init = function()
            vim.opt.formatexpr = [[v:lua.require("conform").formatexpr()]]
        end,
        opts = {
            formatters_by_ft = {
                python = {
                    "ruff_fix",
                    "ruff_fmt",
                },
                ["_"] = { "trim_whitespace" },
            },
            log_level = vim.log.levels.ERROR,
        },
    },
    {
        "mfussenegger/nvim-lint",
        event = {
            "BufReadPost",
            "BufNewFile",
        },
        opts = {
            debounce_ms = 300,
            events = {
                "BufWritePost",
                "BufReadPost",
                "TextChanged",
                "InsertLeave",
            },
            linters_by_ft = {
                python = { "ruff" },
            },
        },
        config = function(_, opts)
            local lint = require("lint")
            local function debounce(ms, callback)
                local timer = vim.loop.new_timer()
                return function(...)
                    local argv = {...}
                    timer:start(ms, 0, function()
                        timer:stop()
                        vim.schedule_wrap(callback)(unpack(argv))
                    end)
                end
            end
            local function try_lint(bufnr)
                if vim.api.nvim_buf_is_valid(bufnr) then
                    vim.api.nvim_buf_call(bufnr, function()
                        lint.try_lint()
                    end)
                end
            end

            lint.linters_by_ft = opts.linters_by_ft
            _G.create_autocmd(opts.events, {
                group = "Lint",
                callback = function(args)
                    debounce(opts.debounce_ms, try_lint)(args.buf)
                end,
            })
        end,
    },
}
