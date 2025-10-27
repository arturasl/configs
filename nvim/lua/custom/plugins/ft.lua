return {
    {
        "hat0uma/csvview.nvim",
        ft = "csv",
        config = function()
            local csvview = require("csvview")
            csvview.setup({
                parser = {
                    delimiter = {
                        ft = {},
                    },
                },
                view = {
                    display_mode = "border",
                },
                keymaps = {
                    jump_next_field_start = { "<Tab>", mode = { "n", "v" } },
                    jump_prev_field_start = { "<S-Tab>", mode = { "n", "v" } },
                },
            })

            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "csv" },
                group = vim.api.nvim_create_augroup("plug_ft_csv", { clear = true }),
                callback = function()
                    csvview.enable()
                    vim.opt_local.wrap = false
                    vim.opt_local.colorcolumn = ""
                end,
            })
        end,
    },

    {
        "eraserhd/parinfer-rust",
        build = "cargo build --release",
        event = "VeryLazy",
    },
    {
        "Olical/conjure",
        ft = { "clojure" },
        init = function()
            vim.g["conjure#mapping#enable_defaults"] = false
            vim.g["conjure#highlight#enabled"] = true
            -- vim.g["conjure#log#hud#enabled"] = false

            vim.g["conjure#mapping#prefix"] = "1"
            vim.g["conjure#mapping#eval_file"] = "f"
            vim.keymap.set("n", "<space>ef", ":ConjureEvalFile<cr>", { desc = "Evaluate [F]ile" })
            vim.g["conjure#mapping#eval_root_form"] = "r"
            vim.keymap.set("n", "<space>er", ":ConjureEvalRootForm<cr>", { desc = "Evaluate [R]oot" })
            vim.g["conjure#mapping#eval_current_form"] = "c"
            vim.keymap.set("n", "<space>ec", ":ConjureEvalCurrentForm<cr>", { desc = "Evaluate [C]urrent" })

            -- By default conjure will disable diagnostics (errors/warnings
            -- shown from linter/lsp).
            vim.g["conjure#log#diagnostics"] = true
        end,
    },
}
