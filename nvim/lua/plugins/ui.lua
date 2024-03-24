return {
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        event = "BufRead",
        cmd = { "IBLEnable", "IBLEnableScope" },
        opts = {
            -- TODO: setup scope once treesitter is setup
            indent = {
                char = "│",
                highlight = "IblIndentDark",
            },
            viewport_buffer = { min = 50 },
        },
        config = function(_, opts)
            local hooks = require("ibl.hooks")
            hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
                local P = require("kanagawa.colors").setup().palette
                vim.api.nvim_set_hl(0, "IblIndentDark", {
                    fg = P.dragonBlack5,
                })
            end)
            hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)

            require("ibl").setup(opts)
        end,
    },
    {
        "utilyre/sentiment.nvim",
        event = "VeryLazy",
        opts = {},
    },
}
