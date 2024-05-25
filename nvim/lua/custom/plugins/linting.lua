return {
    "mfussenegger/nvim-lint",
    dependencies = {
        -- NOTE: Preconfigured separately.
        "williamboman/mason.nvim",
        -- Maps between linters installed by Mason and configurations
        -- managed by nvim-lint.
        "rshkarin/mason-nvim-lint",
    },
    config = function()
        require("lint").linters_by_ft = {
            lua = { "luacheck" },
            cpp = { "cpplint" },
            sh = { "shellcheck" },
            python = { "pylint" },
            javascript = { "eslint_d" },
            typescript = { "eslint_d" },
            css = { "stylelint" },
        }

        -- Call linter after saving the buffer (file has to be written).
        vim.api.nvim_create_autocmd({ "BufWritePost" }, {
            callback = function()
                require("lint").try_lint()
            end,
        })

        -- Has to be after `lint.setup`.
        require("mason-nvim-lint").setup()
    end,
}
