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

                opts.desc = "Smart rename"
                keymap.set("n", "<space>lr", vim.lsp.buf.rename, opts)

                opts.desc = "See available fixes"
                keymap.set({ "n", "v" }, "<space>lf", vim.lsp.buf.code_action, opts)

                opts.desc = "Show documentation for word under cursor"
                keymap.set("n", "K", vim.lsp.buf.hover, opts)

                opts.desc = "Restart LSP"
                keymap.set("n", "<space>lR", "<cmd>LspRestart<cr>", opts)

                opts.desc = "Definition"
                keymap.set("n", "<ctrl>]", vim.lsp.buf.definition, opts)

                opts.desc = "Caller (references)"
                keymap.set("n", "<ctrl>[", vim.lsp.buf.references, opts)

                opts.desc = "Inline hints"
                keymap.set("n", "<space>li", function()
                    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
                end, opts)
            end,
        })

        config.lua_ls.setup({
            on_init = function(client)
                -- Make Lua LSP play nice with NeoVim config.
                -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#lua_ls
                client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
                    runtime = { version = "LuaJIT" },
                    workspace = {
                        checkThirdParty = false,
                        library = vim.api.nvim_get_runtime_file("", true),
                    },
                })
            end,
            settings = { Lua = {} },
        })
        config.clangd.setup({})
        config.rust_analyzer.setup({})
        config.bashls.setup({})
        config.pyright.setup({})
    end,
}
