-- TODO: Set mapping for choosing luasnip choice nodes
return {
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp",
        opts = function()
            local types = require("luasnip.util.types")
            return {
                keep_roots = false,
                link_roots = false,
                link_children = false,
                region_check_events = { "CursorMoved" },
                delete_check_events = { "TextChangedI" },
                ext_opts = {
                    [types.insertNode] = {
                        active = {
                            virt_text = {
                                { "«", "Special" },
                            },
                        },
                    },
                },
            }
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        version = false, -- Last release is way too old
        dependencies = {
            "L3MON4D3/LuaSnip",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "saadparwaiz1/cmp_luasnip",
        },
        event = "InsertEnter",
        cmd = { "CmpStatus" },
        opts = {
            max_index_filesize = 1048576, -- 1MB (1024*1024)
        },
        config = function(_, opts)
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            local cmp_buffer = require("cmp_buffer")

            cmp.setup({
                completion = {
                    completeopt = "menuone,noinsert,noselect",
                },
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
                    ["<Cr>"] = cmp.mapping.confirm({ select = false }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "path" },
                }, {
                    {
                        name = "buffer",
                        keyword_length = 5,
                        option = {
                            get_bufnrs = function()
                                local bufnrs = vim.api.nvim_list_bufs()

                                if #bufnrs == 1 and vim.api.nvim_buf_is_loaded(bufnrs[1]) then
                                    return bufnrs
                                end

                                local buflist = {}
                                for _, bufnr in ipairs(bufnrs) do
                                    local lc = vim.api.nvim_buf_line_count(bufnr)
                                    local bs = vim.api.nvim_buf_get_offset(bufnr, lc)

                                    if bs <= opts.max_index_filesize and vim.api.nvim_buf_is_loaded(bufnr) then
                                        table.insert(buflist, bufnr)
                                    end
                                end

                                return buflist
                            end,
                        },
                    },
                }),
                sorting = {
                    priority_weight = 2,
                    comparators = {
                        -- https://github.com/hrsh7th/cmp-buffer?tab=readme-ov-file#locality-bonus-comparator-distance-based-sorting
                        function(...)
                            return cmp_buffer:compare_locality(...)
                        end,
                        cmp.config.compare.offset,
                        cmp.config.compare.exact,
                        cmp.config.compare.score,
                        -- https://github.com/lukas-reineke/cmp-under-comparator
                        function(entry1, entry2)
                            local _, entry1_under = entry1.completion_item.label:find("^_+")
                            local _, entry2_under = entry2.completion_item.label:find("^_+")
                            entry1_under = entry1_under or 0
                            entry2_under = entry2_under or 0
                            if entry1_under > entry2_under then
                                return false
                            elseif entry1_under < entry2_under then
                                return true
                            end
                        end,
                        cmp.config.compare.recently_used,
                        cmp.config.compare.locality,
                        cmp.config.compare.kind,
                        cmp.config.compare.length,
                        cmp.config.compare.order,
                    },
                },
                experimental = {
                    ghost_text = {
                        hl_group = "LspCodeLens",
                    },
                },
            })
        end,
    },
}
