return {
    -- For better vim lua completions.
    {
        "folke/lazydev.nvim",
        ft = "lua",
        dependencies = {
            -- `vim.uv` typings
            { "Bilal2453/luvit-meta", lazy = true },
        },
        config = function()
            require("lazydev").setup({
                library = { { path = "luvit-meta/library", words = { "vim%.uv" } } },
            })
        end,
    },

    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
        },
        config = function()
            local cmp = require("cmp")

            cmp.setup({
                completion = {
                    -- Ensure first item is selected and hence can be accepted.
                    completeopt = "menu,menuone,noinsert",
                },

                snippet = {
                    expand = function(args)
                        vim.snippet.expand(args.body)
                    end,
                },

                sources = {
                    { group_index = 1, name = "lazydev" },
                    { group_index = 2, name = "path" },
                    { group_index = 3, name = "nvim_lsp" },
                    {
                        group_index = 3,
                        name = "buffer",
                        option = {
                            get_bufnrs = require("custom/functions").visible_buffer_nrs,
                        },
                    },
                },

                mapping = {
                    ["<c-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
                    ["<c-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
                    ["<c-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<c-f>"] = cmp.mapping.scroll_docs(4),
                    ["<c-y>"] = cmp.mapping.confirm({ select = true }),
                    ["<cr>"] = function(fallback)
                        fallback()
                    end,
                },

                experimental = { ghost_text = true },
            })

            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { group_index = 1, name = "path" },
                    { group_index = 2, name = "cmdline", keyword_length = 2 },
                },
            })
        end,
    },
}
