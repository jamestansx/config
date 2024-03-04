local create_autocmd = require("jamestansx.utils").create_autocmd

-- Disable remote plugin providers
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Always leader first!!!
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.keymap.set("", "<Space>", "<Nop>", { silent = true })

--------------------------------------------------------------------------------
--
-- Preferences
--
--------------------------------------------------------------------------------

-- Line numbers is a MUST
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true

-- Nice to have UI
vim.opt.pumblend = 10
vim.opt.winblend = 10
vim.opt.title = true
vim.opt.titlestring = "%{getpid().':'.getcwd()}"
vim.opt.colorcolumn = "+1"
vim.opt.cmdheight = 2
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 2
vim.opt.sidescrolloff = 5

-- Keep current window on top-left corner
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Less is more
vim.opt.pumheight = 5
vim.opt.laststatus = 3
vim.opt.showmode = false
vim.opt.shortmess:append({
    I = true, -- Intro message
    C = true, -- "scanning tags"
    c = true, -- Ins-completion messages
    a = true, -- :help 'shortmess'
})

vim.opt.hlsearch = false
-- \C to disable case-insensitive searching
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.redrawtime = 1000
vim.opt.timeoutlen = 300
vim.opt.ttimeoutlen = 10

-- Xterm style mouse model
vim.opt.mouse = "a"
vim.opt.mousemodel = "extend"

vim.opt.confirm = true
vim.opt.undofile = true
vim.opt.autowriteall = true
vim.opt.virtualedit = { "block" }
vim.opt.jumpoptions = { "stack", "view" }
vim.opt.smartindent = true
vim.opt.shiftround = true

-- XXX: Do I need to enable exrc?
vim.opt.exrc = true
vim.opt.modelines = 1
vim.opt.shada:append({
    "r/tmp/",
})

-- Display showbreak character if wrap is enabled
vim.opt.wrap = false
vim.opt.breakindent = true
vim.opt.breakindentopt = { "sbr" }
vim.opt.showbreak = "↪"
vim.opt.linebreak = true

-- Show more hidden characters
vim.opt.list = true
vim.opt.listchars = {
    trail = "·",
    tab = "  ⇥",
    nbsp = "¬",
    extends = "→",
    precedes = "←",
}
vim.opt.fillchars = {
    fold = " ",
    foldopen = "▽",
    foldsep = " ",
    foldclose = "▷",
}

-- Useful diffs (nvim -d)
vim.opt.diffopt:append({
    "iwhite",
    "indent-heuristic",
    "algorithm:histogram",
    "linematch:60",
})

-- Decent wildmenu
vim.opt.wildmode = { "longest:full", "full" }
vim.opt.wildignorecase = true
vim.opt.wildignore:append({ "*/.git/*", "*/.hg/*", "*/.svn/*" }) -- vcs
vim.opt.wildignore:append({ "*.swp", "*.lock", "*.cache" }) -- caches
vim.opt.wildignore:append({ "*.pyc", "*.pycache", "**/__pycache__/**" }) -- python
vim.opt.wildignore:append({ "**/node_modules/**" }) -- javascript
vim.opt.wildignore:append({ "*.o", "*.out", "*.obj", "*~" }) -- compiled files
vim.opt.wildignore:append({ "*.bmp", "*.gif", "*.ico", "*.png", "*.jpg", "*.jpeg", "*.webp" }) -- pictures
vim.opt.wildignore:append({ "*.zip", "*.gz", "*.bz2" }) -- zip

-- :help isfname
vim.opt.isfname:append("@-@")

-- https://vi.stackexchange.com/a/9366/37072
create_autocmd("FileType", {
    group = "SetFormatOptions",
    command = [[setlocal formatoptions-=o]],
})

if vim.fn.executable("rg") == 1 then
    vim.opt.grepprg = "rg --no-heading --smart-case --vimgrep"
    vim.opt.grepformat = { "%f:%l:%c:%m", "%f:%l:%m" }
end

vim.diagnostic.config({
    virtual_text = { source = "if_many" },
    severity_sort = true,
    update_in_insert = true,
})

vim.fn.sign_define("DiagnosticSignError", { text = "E", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "W", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = "I", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "H", texthl = "DiagnosticSignHint" })

--------------------------------------------------------------------------------
--
-- Hotkeys
--
--------------------------------------------------------------------------------

-- Center search result
vim.keymap.set("n", "n", "nzzzv", { silent = true })
vim.keymap.set("n", "N", "Nzzzv", { silent = true })
vim.keymap.set("n", "*", "*zzzv", { silent = true })
vim.keymap.set("n", "#", "#zzzv", { silent = true })
vim.keymap.set("n", "g*", "g*zzzv", { silent = true })

-- Disable arrow keys
vim.keymap.set("", "<Up>", "<Nop>")
vim.keymap.set("", "<Down>", "<Nop>")
vim.keymap.set("", "<Left>", "<Nop>")
vim.keymap.set("", "<Right>", "<Nop>")

vim.keymap.set("x", "<", "<gv", { silent = true })
vim.keymap.set("x", ">", ">gv", { silent = true })
vim.keymap.set("n", "J", "mzJ`z", { silent = true })

-- Select last pasted text
vim.keymap.set("n", "gp", "`[v`]", { silent = true })

-- https://github.com/mhinz/vim-galore#saner-command-line-history
vim.keymap.set("c", "<C-n>", function()
    return vim.fn.wildmenumode() == 1 and "<C-n>" or "<Down>"
end, { expr = true })
vim.keymap.set("c", "<C-p>", function()
    return vim.fn.wildmenumode() == 1 and "<C-p>" or "<Up>"
end, { expr = true })

-- System clipboard
vim.keymap.set({ "n", "x" }, "<leader>y", [["+y]])
vim.keymap.set({ "n", "x" }, "<leader>p", [["+p]])
vim.keymap.set({ "n", "x" }, "<leader>d", [["_d]])

-- Diagnostics
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)

-- TODO: Grab some useful keymap from vim-unimpaired

--------------------------------------------------------------------------------
--
-- Autocommands
--
--------------------------------------------------------------------------------

create_autocmd("TextYankPost", {
    group = "HiTextOnYank",
    callback = function()
        vim.highlight.on_yank({
            timeout = 50
        })
    end,
})

create_autocmd("BufRead", {
    group = "RestoreCursor",
    callback = function()
        create_autocmd("FileType", {
            group = "RestoreCursor",
            buffer = 0,
            once = true,
            callback = function()
                local ft_ignore = { "gitcommit", "gitrebase", "help", "lazy" }
                if vim.tbl_contains(ft_ignore, vim.bo.ft) then
                    return
                end

                local mark = vim.api.nvim_buf_get_mark(0, '"')
                if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(0) then
                    pcall(vim.api.nvim_win_set_cursor, 0, mark)
                end
            end,
        })
    end,
})

create_autocmd("BufNewFile", {
    group = "MakeDirectory",
    callback = function()
        create_autocmd("BufWritePre", {
            group = "MakeDirectory",
            buffer = 0,
            once = true,
            callback = function(args)
                -- Ignore URL pattern
                if not args.match:match("^%w+://") then
                    local file = vim.loop.fs_realpath(args.match) or args.match
                    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
                end
            end,
        })
    end,
})

--------------------------------------------------------------------------------
--
-- Plugins
--
--------------------------------------------------------------------------------
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- XXX: Allow init.lua to be re-sourced
if package.loaded["lazy"] == nil then
    require("lazy").setup({
        { import = "plugins" },
    }, {
        defaults = { lazy = true },
        install = { colorscheme = { "kanagawa" } },
        checker = { enabled = false },
        change_detection = { notify = false },
        performance = {
            rtp = {
                disabled_plugins = {
                    "gzip",
                    "rplugin",
                    "tarPlugin",
                    "tohtml",
                    "tutor",
                    "zipPlugin",
                },
            },
        },
    })
end
