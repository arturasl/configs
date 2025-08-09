return {
    {
        "rebelot/kanagawa.nvim",
        priority = 1000, -- Load first.
        dependencies = {
            "folke/tokyonight.nvim",
            "EdenEast/nightfox.nvim",
            "catppuccin/nvim",
            "Mofiqul/dracula.nvim",
            "AlexvZyl/nordic.nvim",
            "bluz71/vim-nightfly-colors",
            "scottmckendry/cyberdream.nvim",
            "marko-cerovac/material.nvim",
            "vague2k/vague.nvim",
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
                "dracula",
                "nordic",
                "nightfly",
                "cyberdream",
                "material-deep-ocean",
                "material-darker",
                "material-palenight",
                "vague",
            }
            local days_since_epoch = math.floor(os.time() / (60 * 60 * 24))
            assert(7 % #schemes ~= 0)
            vim.cmd.colorscheme(schemes[(days_since_epoch * 7) % #schemes + 1])
        end,
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("todo-comments").setup({})
        end,
    },
}
