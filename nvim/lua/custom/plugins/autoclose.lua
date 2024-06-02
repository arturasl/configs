return {
    -- Finishes quotation marks, braces, parenthesis, etc.
    {
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup({ disable_in_macro = false })
        end,
    },

    -- Finishes xml tags `<div>` will automatically insert `</div>`.
    {
        "windwp/nvim-ts-autotag",
        config = function()
            require("nvim-ts-autotag").setup()
        end,
    },

    -- Finishes "blocks" like patterns, e.g. for `function() <cr>` will
    -- automatically insert `end`.
    {
        "tpope/vim-endwise",
    },
}
