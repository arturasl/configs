return {
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
            snippet = {
                expand = function(args)
                    vim.snippet.expand(args.body)
                end,
            },

            sources = cmp.config.sources(
                -- Priority group 1.
                {
                    { name = "nvim_lsp" },
                    { name = "path" },
                },
                -- Priority group 2.
                {
                    { name = "buffer" },
                }
            ),

            mapping = cmp.mapping.preset.insert({
                ["<c-n>"] = cmp.mapping(cmp.mapping.select_next_item()),
                ["<c-p>"] = cmp.mapping(cmp.mapping.select_prev_item()),
                ["<c-b>"] = cmp.mapping.scroll_docs(-4),
                ["<c-f>"] = cmp.mapping.scroll_docs(4),
                ["<cr>"] = cmp.mapping.confirm({
                    -- Only accept item if it was explicitly selected with
                    -- <c-n>/<c-p>.
                    select = false,
                }),
            }),
        })

        cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources(
                -- Priority group 1.
                {
                    { name = "path" },
                },
                -- Priority group 2.
                {
                    {
                        name = "cmdline",
                        keyword_length = 2,
                    },
                }
            ),
            matching = { disallow_symbol_nonprefix_matching = false },
        })
    end,
}
