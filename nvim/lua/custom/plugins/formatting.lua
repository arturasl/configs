return {
    "stevearc/conform.nvim",
    dependencies = {
        -- NOTE: Preconfigured separately.
        "mason-org/mason.nvim",
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
                python = { "ruff_organize_imports", "ruff_format" },
                javascript = { "prettier" },
                typescript = { "prettier" },
                css = { "prettier" },
                html = { "prettier" },
                json = { "prettier" },
                yaml = { "prettier" },
                markdown = { "prettier" },
            },
            format_after_save = {
                timeout_ms = 500,
                lsp_format = "fallback",
            },
        })

        -- Has to be after `conform.setup`.
        require("mason-conform").setup()
    end,
}
