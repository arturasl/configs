return {
    "stevearc/dressing.nvim",
    config = function()
        require("dressing").setup({
            select = {
                backend = { "builtin" },
            },
        })
    end,
}
