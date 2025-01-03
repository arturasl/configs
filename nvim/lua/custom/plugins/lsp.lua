return {
    "neovim/nvim-lspconfig",
    dependencies = {
        -- NOTE: Preconfigured separately.
        "williamboman/mason.nvim",
        -- Maps between LSPs installed by Mason and configurations managed
        -- by nvim-lspconfig.
        "williamboman/mason-lspconfig.nvim",
    },
    config = function()
        require("mason-lspconfig").setup({
            -- Install servers that were configured by lspconfig.
            automatic_installation = true,
        })
        local config = require("lspconfig")

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

                opts.desc = "Caller (references)"
                keymap.set("n", "<ctrl>[", vim.lsp.buf.references, opts)

                opts.desc = "[I]nline hints"
                keymap.set("n", "<space>li", function()
                    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
                end, opts)
            end,
        })

        config.lua_ls.setup({})
        config.clangd.setup({})
        config.rust_analyzer.setup({
            settings = {
                ["rust-analyzer"] = {
                    checkOnSave = {
                        command = "clippy",
                    },
                },
            },
        })

        config.bashls.setup({})
        config.pyright.setup({})
        config.texlab.setup({})
    end,
}
