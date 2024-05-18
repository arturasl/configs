return {
    "stevearc/conform.nvim",
    dependencies = {
        -- NOTE: Preconfigured separately.
        "williamboman/mason.nvim",
        -- Maps between formatters installed by Mason and configurations
        -- managed by conform.
        "zapling/mason-conform.nvim",
    },
    config = function()
        require("conform").setup({
            formatters_by_ft = {
                lua = { "stylua" },
                -- cpp = handled by LSP.
                -- rust = handled by LSP.
                sh = { "beautysh" },
                python = { "isort", "black" },
                javascript = { "prettier" },
                typescript = { "prettier" },
                css = { "prettier" },
                html = { "prettier" },
                json = { "prettier" },
                yaml = { "prettier" },
                markdown = { "prettier" },
            },
            format_on_save = {
                lsp_fallback = true,
                async = false,
                timeout_ms = 1000,
            },
        })

        -- Has to be after `conform.setup`.
        require("mason-conform").setup()
    end,
}
