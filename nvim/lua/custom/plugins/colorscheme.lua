return {
    "rebelot/kanagawa.nvim",
    priority = 1000, -- Load first.
    dependencies = {
        "folke/tokyonight.nvim",
    },
    config = function()
        local schemes = {
            "tokyonight-storm",
            "tokyonight-moon",
            "kanagawa",
        }
        local weeks_since_epoch = math.floor(os.time() / (60 * 60 * 24 * 7))
        vim.cmd.colorscheme(schemes[weeks_since_epoch % #schemes + 1])
    end,
}
