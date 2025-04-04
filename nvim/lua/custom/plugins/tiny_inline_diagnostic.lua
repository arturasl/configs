return {
    "rachartier/tiny-inline-diagnostic.nvim",
    priority = 1000,
    config = function()
        vim.diagnostic.config({ virtual_text = false })
        require("tiny-inline-diagnostic").setup({
            options = {
                multiple_diag_under_cursor = true,
                multilines = {
                    enabled = true,
                    always_show = true,
                },
            },
        })
    end,
}
