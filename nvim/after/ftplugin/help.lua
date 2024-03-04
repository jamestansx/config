vim.wo.colorcolumn = ""

vim.keymap.set("n", "q", "<Cmd>helpclose<Cr>", {
    buffer = true,
    nowait = true,
    silent = true,
    noremap = true,
})
