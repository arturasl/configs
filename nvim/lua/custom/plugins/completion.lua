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
        "L3MON4D3/LuaSnip",
        config = function()
            require("luasnip").setup({})
            require("luasnip.loaders.from_snipmate").lazy_load()
        end,
    },

    {
        "Saghen/blink.cmp",
        dependencies = {},
        build = "cargo build --release",
        opts = {
            keymap = { preset = "default" },
            completion = {
                documentation = {
                    auto_show = true,
                },
                -- Select first item so that <C-y> would accept it, but do
                -- not insert (even while iterating through
                -- completions) -- just show ghost text.
                ghost_text = { enabled = true },
                list = { selection = { preselect = true, auto_insert = false } },
            },
            snippets = {
                preset = "luasnip",
            },
            signature = {
                enabled = true,
            },
            cmdline = {
                completion = {
                    menu = {
                        auto_show = true,
                    },
                },
            },
            sources = {
                -- Note: `buffer` takes words from all visible buffers.
                -- Note: `buffer` sometimes trigger only in the comments.
                default = { "lazydev", "lsp", "path", "snippets", "buffer" },
                providers = {
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        score_offset = 100,
                    },
                },
            },
            fuzzy = { implementation = "rust" },
        },
        opts_extend = { "sources.default" },
    },
}
