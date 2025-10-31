return {
    {
        -- Installs LSP servers, formatters, linters, etc.
        "mason-org/mason.nvim",
        build = ":MasonUpdateAll",
        dependencies = {
            {
                "RubixDev/mason-update-all",
                config = function()
                    require("mason-update-all").setup({
                        show_no_updates_notification = false,
                    })
                end,
            },
        },
        config = function()
            require("mason").setup()
        end,
    },
}
