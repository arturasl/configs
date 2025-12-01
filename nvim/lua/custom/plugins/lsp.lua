return {
    {
        "rachartier/tiny-inline-diagnostic.nvim",
        event = "LspAttach",
        config = function()
            vim.diagnostic.config({
                virtual_text = false,
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = "●",
                        [vim.diagnostic.severity.WARN] = "●",
                    },
                },
            })

            require("tiny-inline-diagnostic").setup({
                options = {
                    show_source = {
                        enabled = true,
                    },
                    multilines = {
                        enabled = true,
                        always_show = true,
                    },
                },
            })
        end,
    },

    {
        "rachartier/tiny-code-action.nvim",
        keys = {
            {
                "<space>lf",
                function()
                    require("tiny-code-action").code_action({})
                end,
                desc = "See available [F]ixes",
            },
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
        },
        config = function()
            require("tiny-code-action").setup({
                backend = "delta", -- Requires `pacman -S git-delta`.
                picker = {
                    "telescope",
                    opts = require("telescope.themes").get_dropdown({
                        initial_mode = "normal",
                        layout_config = { height = 10 },
                    }),
                },
            })
        end,
    },

    {
        "neovim/nvim-lspconfig",
        dependencies = {
            -- NOTE: Preconfigured separately.
            "mason-org/mason.nvim",
            -- Maps between LSPs installed by Mason and configurations managed
            -- by nvim-lspconfig.
            "mason-org/mason-lspconfig.nvim",
            "nvim-telescope/telescope.nvim",
        },
        config = function()
            local telescope = require("telescope.builtin")

            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("custom_lsp_overrides", { clear = true }),
                callback = function(evt)
                    local keymap = vim.keymap
                    local opts = { buffer = evt.buf, silent = true }

                    opts.desc = "Smart [R]ename"
                    keymap.set("n", "<space>lr", vim.lsp.buf.rename, opts)

                    opts.desc = "Show documentation for word under cursor"
                    keymap.set("n", "K", vim.lsp.buf.hover, opts)

                    opts.desc = "[R]estart LSP"
                    keymap.set("n", "<space>lR", "<cmd>LspRestart<cr>", opts)

                    opts.desc = "Definition"
                    keymap.set("n", "<ctrl>]", vim.lsp.buf.definition, opts)

                    opts.desc = "[U]sages (references)"
                    keymap.set("n", "<space>lu", telescope.lsp_references, opts)

                    opts.desc = "[D]iagnostics"
                    keymap.set("n", "<space>ld", function()
                        telescope.diagnostics({ bufnr = 0 })
                    end, opts)

                    opts.desc = "[I]nline hints"
                    keymap.set("n", "<space>li", function()
                        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
                    end, opts)
                end,
            })

            local function setup(server, opts)
                if opts ~= nil then
                    vim.lsp.config(server, opts)
                end
                vim.lsp.enable(server)
            end

            setup("lua_ls")
            setup("clangd", {
                init_options = {
                    fallbackFlags = { "-std=c++23" },
                },
            })
            setup("rust_analyzer", {
                settings = {
                    ["rust-analyzer"] = {
                        checkOnSave = {
                            command = "clippy",
                        },
                        diagnostics = { disabled = { "unresolved-proc-macro" } },
                    },
                },
            })
            setup("bashls")
            setup("basedpyright")
            setup("texlab")
            setup("clojure_lsp")
            setup("ts_ls")

            -- Install servers that were configured by lspconfig.
            -- Has to be after `setup`s.
            require("mason-lspconfig").setup({
                ensure_installed = vim.tbl_keys(vim.lsp._enabled_configs),
                automatic_enable = false,
            })
        end,
    },
}
