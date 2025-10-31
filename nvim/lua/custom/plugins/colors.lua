local M = {}

local color_scheme_plugins = {
    {
        name = "rebelot/kanagawa.nvim",
        provides = {
            "kanagawa",
        },
    },
    {
        name = "folke/tokyonight.nvim",
        provides = {
            "tokyonight-moon",
            "tokyonight-storm",
        },
    },
    {
        name = "EdenEast/nightfox.nvim",
        provides = {
            "carbonfox",
            "duskfox",
            "nightfox",
            "terafox",
        },
    },
    {
        name = "catppuccin/nvim",
        provides = {
            "catppuccin-macchiato",
            "catppuccin-mocha",
            "catppuccin-frappe",
        },
    },
    {
        name = "Mofiqul/dracula.nvim",
        provides = {
            "dracula",
        },
    },
    {
        name = "AlexvZyl/nordic.nvim",
        provides = {
            "nordic",
        },
    },
    {
        name = "bluz71/vim-nightfly-colors",
        provides = {
            "nightfly",
        },
    },
    {
        name = "scottmckendry/cyberdream.nvim",
        provides = {
            "cyberdream",
        },
    },
    {
        name = "marko-cerovac/material.nvim",
        provides = {
            "material-deep-ocean",
            "material-darker",
            "material-palenight",
        },
    },
    {
        name = "vague2k/vague.nvim",
        provides = {
            "vague",
        },
    },
}

local linearized_schemes = {}
for _, plugin in ipairs(color_scheme_plugins) do
    for _, scheme in ipairs(plugin.provides) do
        linearized_schemes[#linearized_schemes + 1] = {
            plugin_name = plugin.name,
            scheme_name = scheme,
        }
    end
end
local days_since_epoch = math.floor(os.time() / (60 * 60 * 24))
assert(7 % #linearized_schemes ~= 0)
local picked_scheme = linearized_schemes[(days_since_epoch * 7) % #linearized_schemes + 1]

for _, plugin in ipairs(color_scheme_plugins) do
    local add = { plugin.name }
    if picked_scheme.plugin_name == plugin.name then
        add.priority = 1000
        add.config = function()
            vim.cmd.colorscheme(picked_scheme.scheme_name)
        end
    else
        add.lazy = true
    end

    M[#M + 1] = add
end

M[#M + 1] = {
    "folke/todo-comments.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        require("todo-comments").setup({})
    end,
}

M[#M + 1] = {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require("colorizer").setup({
            user_default_options = {
                css = true,
                mode = "virtualtext",
                names = false, -- Disable showing colors for names like "black".
            },
        })
    end,
}

return M
