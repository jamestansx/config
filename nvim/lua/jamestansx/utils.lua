local M = {}


function M.create_autocmd(args, opts)
    if opts.group and vim.fn.exists("#" .. opts.group) == 0 then
        vim.api.nvim_create_augroup(opts.group, { clear = true })
    end
    vim.api.nvim_create_autocmd(args, opts)
end

return M
