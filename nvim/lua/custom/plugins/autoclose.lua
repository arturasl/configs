return {
    -- Finishes quotation marks, braces, parenthesis, etc.
    {
        "windwp/nvim-autopairs",
        event = { "InsertEnter" },
        opts = {
            disable_in_macro = false,
            disable_filetype = { "clojure" },
        },
    },

    -- Finishes xml tags `<div>` will automatically insert `</div>`.
    {
        "windwp/nvim-ts-autotag",
        event = { "InsertEnter" },
        opts = {},
    },

    -- Finishes "blocks" like patterns, e.g. for `function() <cr>` will
    -- automatically insert `end`.
    {
        "RRethy/nvim-treesitter-endwise",
    },
}
