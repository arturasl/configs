local semgrep_config_fn = function()
    local confs = vim.fs.find("semgrep.yaml", {
        upward = true,
        limit = 1,
    })
    local cmd = "semgrep"

    return {
        name = cmd,
        cmd = confs[1] and cmd or "true",
        stdin = false,
        stream = "stdout",
        args = {
            "scan",
            "--quiet",
            "--json",
            "--config",
            confs[1],
        },
        ignore_exitcode = true,
        parser = function(output)
            local errors = {}
            if output == "" then
                return errors
            end
            local json = vim.json.decode(output)

            for _, item in ipairs(json.results or {}) do
                local estart = item["start"]
                local eend = item["end"] -- Note: `end` is a special keyword.
                table.insert(errors, {
                    source = cmd,
                    lnum = estart.line - 1,
                    col = estart.col - 1,
                    end_lnum = eend.line - 1,
                    end_col = eend.col - 1,
                    severity = vim.diagnostic.severity.WARN,
                    message = item.extra.message,
                })
            end

            return errors
        end,
    }
end

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

        lint.linters.semgrep = semgrep_config_fn

        lint.linters_by_ft = {
            lua = { "luacheck", "semgrep" },
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
            "-whitespace/comments", -- At least two spaces is best between code and comments.
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
