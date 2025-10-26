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

    { "eraserhd/parinfer-rust", build = "cargo build --release" },
    {
        "Olical/conjure",
        ft = { "clojure" },
        init = function()
            vim.g["conjure#mapping#enable_defaults"] = false
            vim.g["conjure#highlight#enabled"] = true
            -- vim.g["conjure#log#hud#enabled"] = false

            vim.g["conjure#mapping#prefix"] = "1"
            vim.g["conjure#mapping#eval_current_form"] = "e"
            vim.g["conjure#mapping#eval_root_form"] = "E"

            vim.keymap.set("n", "<space>ec", ":ConjureEvalCurrentForm<cr>", { desc = "Evaluate [C]urrent" })
            vim.keymap.set("n", "<space>er", ":ConjureEvalRootForm<cr>", { desc = "Evaluate [R]oot" })

            local lein_repl_jobid = nil
            local start_repl_if_needed = function()
                if lein_repl_jobid then
                    local status = vim.fn.jobwait({ lein_repl_jobid }, 0)[1]
                    if status == -1 then -- `jobwait` timed out == job still runs.
                        return
                    end
                end

                local lein_project_root = vim.fs.root(vim.fn.getcwd(), { "project.clj" })
                if not lein_project_root then
                    return
                end

                lein_repl_jobid = vim.fn.jobstart({
                    "lein",
                    "update-in",
                    ":plugins",
                    "conj",
                    "[cider/cider-nrepl RELEASE]",
                    "--",
                    "repl",
                }, { cwd = lein_project_root })
            end

            vim.api.nvim_create_autocmd("BufReadPost", {
                pattern = { "*.clj" },
                group = vim.api.nvim_create_augroup("clojure_start_repl", { clear = true }),
                callback = start_repl_if_needed,
            })
        end,
    },
}
