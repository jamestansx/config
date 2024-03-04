return {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    init = function()
        vim.cmd.colorscheme("kanagawa")
    end,
    opts = {
        background = {
            dark = "dragon",
        },
        compile = true,
        transparent = true,
        overrides = function(C)
            local T = C.theme

            return {
                -- https://github.com/rebelot/kanagawa.nvim#dark-completion-popup-menu
                Pmenu = {
                    fg = T.ui.shade0,
                    bg = T.ui.bg_p1,
                    blend = vim.o.pumblend,
                },
                PmenuSel = { fg = "NONE", bg = T.ui.bg_p2 },
                PmenuSbar = { bg = T.ui.bg_m1 },
                PmenuThumb = { bg = T.ui.bg_p2 },
            }
        end,
    },
}
