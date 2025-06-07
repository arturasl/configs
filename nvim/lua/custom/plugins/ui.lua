return {
    {
        "stevearc/dressing.nvim",
        config = function()
            require("dressing").setup({
                select = {
                    backend = { "builtin" },
                },
            })
        end,
    },

    {
        "sphamba/smear-cursor.nvim",
        config = function()
            require("smear_cursor").setup({
                -- Faster smear.
                stiffness = 0.8,
                trailing_stiffness = 0.5,
                distance_stop_animating = 0.5,
                smear_to_cmd = true,
            })
        end,
    },

    {
        "karb94/neoscroll.nvim",
        config = function()
            require("neoscroll").setup({
                duration_multiplier = 0.3,
            })
        end,
    },
}
