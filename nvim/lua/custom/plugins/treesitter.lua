return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup({
            -- Required fields, setting to unset to make Lua LSP happy.
            ensure_installed = {},
            sync_install = false,
            ignore_install = {},
            modules = {},
            -- Auto install treesitter parser on opening certain file type
            -- first time.
            auto_install = true,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
            indent = { enable = true },
        })
    end,
}
