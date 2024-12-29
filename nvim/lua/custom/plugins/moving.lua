return {
    {
        -- Additional text object for action based on indentation level.
        -- vii -- visual inside current indentation block;
        -- vai -- visual inside current block + line before;
        -- vaI -- visual inside current block + line before + line after;
        "michaeljsmith/vim-indent-object",
    },
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {},
        keys = {
            {
                "<space><space>",
                mode = { "n", "x", "o" },
                function()
                    require("flash").jump()
                end,
                desc = "Flash",
            },
            {
                "S",
                mode = { "n", "x", "o" },
                function()
                    require("flash").treesitter()
                end,
                desc = "Flash Treesitter",
            },
        },
    },
}
