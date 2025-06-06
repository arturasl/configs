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
                -- Do not jump to cmd (after pressing `:`).
                -- BUG: https://github.com/sphamba/smear-cursor.nvim/issues/78
                smear_to_cmd = false,
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
