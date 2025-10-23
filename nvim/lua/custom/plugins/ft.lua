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
        dependencies = {
            "clojure-vim/vim-jack-in",
            dependencies = {
                "radenling/vim-dispatch-neovim",
                dependencies = { "tpope/vim-dispatch" },
            },
        },
        init = function()
            vim.g["conjure#mapping#enable_defaults"] = false
            vim.g["conjure#highlight#enabled"] = true
            vim.g["conjure#log#hud#enabled"] = false

            vim.g["conjure#mapping#prefix"] = "1"
            vim.g["conjure#mapping#eval_current_form"] = "e"
            vim.g["conjure#mapping#eval_root_form"] = "E"

            vim.keymap.set("n", "<space>ec", ":ConjureEvalCurrentForm<cr>", { desc = "Evaluate [C]urrent" })
            vim.keymap.set("n", "<space>er", ":ConjureEvalRootForm<cr>", { desc = "Evaluate [R]oot" })

            local start_repl_if_needed = function()
                local is_lein_project = vim.fs.root(vim.fn.getcwd(), { "project.clj" })
                if not is_lein_project then
                    return
                end

                local is_lein_open = vim.tbl_contains(vim.api.nvim_list_bufs(), function(bufnr)
                    return vim.api.nvim_buf_get_name(bufnr):find("term://.*%d+:lein ") ~= nil
                end, { predicate = true })
                if is_lein_open then
                    return
                end

                require("custom/functions").preserve_cursor(function()
                    vim.cmd("silent! :Lein")
                end)
            end

            vim.api.nvim_create_autocmd("BufReadPost", {
                pattern = { "*.clj" },
                group = vim.api.nvim_create_augroup("clojure_start_repl", { clear = true }),
                callback = function()
                    vim.defer_fn(start_repl_if_needed, 1000)
                end,
            })
        end,
    },
}
