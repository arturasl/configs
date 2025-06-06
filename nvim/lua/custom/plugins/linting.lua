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
        local lint = require("lint")

        lint.linters_by_ft = {
            lua = { "luacheck" },
            cpp = { "cpplint" },
            sh = { "shellcheck" },
            python = { "pylint" },
            javascript = { "eslint_d" },
            typescript = { "eslint_d" },
            css = { "stylelint" },
        }

        table.insert(lint.linters.pylint.args, "--disable=" .. table.concat({
            "missing-module-docstring",
            "missing-class-docstring",
            "missing-function-docstring",
            "import-error",
        }, ","))

        -- Call linter after saving the buffer (file has to be written).
        vim.api.nvim_create_autocmd({ "BufWritePost" }, {
            callback = function()
                lint.try_lint()
            end,
        })

        -- Has to be after `lint.setup`.
        require("mason-nvim-lint").setup()
    end,
}
