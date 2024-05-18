return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
        -- Allow multi key sequences to cancel after given amount of time.
        -- Cancelation will trigger which-key.
        vim.o.timeout = true
        vim.o.timeoutlen = 500
    end,
    config = function()
        require("which-key").setup()
    end,
}
