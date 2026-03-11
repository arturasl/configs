return {
    {
        "karb94/neoscroll.nvim",
        event = "VeryLazy",
        config = function()
            require("neoscroll").setup({
                duration_multiplier = 0.3,
            })
        end,
    },
}
