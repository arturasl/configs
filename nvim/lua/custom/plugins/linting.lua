return {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        -- NOTE: Preconfigured separately.
        "mason-org/mason.nvim",
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
            clojure = { "clj-kondo" },
        }

        table.insert(lint.linters.pylint.args, "--disable=" .. table.concat({
            "missing-module-docstring",
            "missing-class-docstring",
            "missing-function-docstring",
            "import-error",
        }, ","))

        table.insert(lint.linters.cpplint.args, "--filter=" .. table.concat({
            "-legal/copyright",
            "-build/namespaces",
        }, ","))

        -- Call linter after saving the buffer (file has to be written).
        vim.api.nvim_create_autocmd({ "BufWritePost" }, {
            callback = function()
                lint.try_lint()
            end,
        })

        -- Has to be after `lint.setup`.
        require("mason-nvim-lint").setup({ quiet_mode = true })
    end,
}
