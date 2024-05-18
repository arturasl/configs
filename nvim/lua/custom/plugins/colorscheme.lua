return {
    "rebelot/kanagawa.nvim",
    priority = 1000, -- Load first.
    config = function()
        vim.cmd.colorscheme("kanagawa")
    end,
}
