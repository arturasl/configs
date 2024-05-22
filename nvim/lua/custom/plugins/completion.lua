return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
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
                ["<cr>"] = cmp.mapping.confirm({ select = true }),
            }),
        })
    end,
}
