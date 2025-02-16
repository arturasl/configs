return {
    "rebelot/kanagawa.nvim",
    priority = 1000, -- Load first.
    dependencies = {
        "folke/tokyonight.nvim",
        "EdenEast/nightfox.nvim",
        "catppuccin/nvim",
    },
    config = function()
        local schemes = {
            "carbonfox",
            "duskfox",
            "kanagawa",
            "nightfox",
            "terafox",
            "tokyonight-moon",
            "tokyonight-storm",
            "catppuccin-macchiato",
            "catppuccin-mocha",
            "catppuccin-frappe",
        }
        local weeks_since_epoch = math.floor(os.time() / (60 * 60 * 24 * 7))
        vim.cmd.colorscheme(schemes[weeks_since_epoch % #schemes + 1])
    end,
}
