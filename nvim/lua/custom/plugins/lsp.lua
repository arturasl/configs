return {
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
        local telscope = require("telescope.builtin")

        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("custom_lsp_overrides", { clear = true }),
            callback = function(evt)
                local keymap = vim.keymap
                local opts = { buffer = evt.buf, silent = true }

                opts.desc = "Smart [R]ename"
                keymap.set("n", "<space>lr", vim.lsp.buf.rename, opts)

                opts.desc = "See available [F]ixes"
                keymap.set({ "n", "v" }, "<space>lf", vim.lsp.buf.code_action, opts)

                opts.desc = "Show documentation for word under cursor"
                keymap.set("n", "K", vim.lsp.buf.hover, opts)

                opts.desc = "[R]estart LSP"
                keymap.set("n", "<space>lR", "<cmd>LspRestart<cr>", opts)

                opts.desc = "Definition"
                keymap.set("n", "<ctrl>]", vim.lsp.buf.definition, opts)

                opts.desc = "[U]sages (references)"
                keymap.set("n", "<space>lu", telscope.lsp_references, opts)

                opts.desc = "[D]iagnostics"
                keymap.set("n", "<space>ld", function()
                    telscope.diagnostics({ bufnr = 0 })
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

        -- Install servers that were configured by lspconfig.
        -- Has to be after `setup`s.
        require("mason-lspconfig").setup({
            ensure_installed = vim.tbl_keys(vim.lsp._enabled_configs),
            automatic_enable = false,
        })
    end,
}
