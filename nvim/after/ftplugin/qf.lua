vim.wo.wrap = false
vim.wo.colorcolumn = ""
vim.wo.list = false

vim.keymap.set("n", "q", "<C-w>c", {
    silent = true,
    buffer = true,
    nowait = true,
    noremap = true,
})

_G.create_autocmd("BufEnter", {
    group = "qf",
    buffer = 0,
    nested = true,
    callback = function()
        if vim.fn.winnr("$") < 2 then
            vim.cmd([[silent quit]])
        end
    end,
})
