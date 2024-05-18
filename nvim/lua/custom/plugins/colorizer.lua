return {
    "NvChad/nvim-colorizer.lua",
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
