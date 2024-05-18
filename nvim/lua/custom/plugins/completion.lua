return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        -- Snippet engine, only using for completion purposes.
        "hrsh7th/cmp-vsnip",
        "hrsh7th/vim-vsnip",
    },
    config = function()
        local cmp = require("cmp")
        cmp.setup({
            snippet = {
                expand = function(args)
                    vim.fn["vsnip#anonymous"](args.body)
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
                ["<cr>"] = cmp.mapping.confirm({ select = true }),
            }),
        })
    end,
}
