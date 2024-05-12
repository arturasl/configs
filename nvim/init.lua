vim.opt.number = true -- Show number line.
vim.opt.mouse = "a" -- More mouse please :)
vim.opt.cursorline = true -- Highlight current line.
vim.opt.colorcolumn = "81" -- Column list to highligh (now only 80).
vim.opt.scrolloff = 10 -- Try to show atleast num lines.
vim.opt.autochdir = true -- File commands are relative to cur directory.
vim.opt.shell = "bash" -- Always use bash as shell for vim.
vim.opt.fileformats = "unix,dos,mac" -- Use \n for new lines by default (unless file uses \r\n or \r).
vim.opt.fileencodings = "ucs-bom,utf-8,latin1" -- Encodings to try for existing files (for new one - utf-8).
vim.opt.lazyredraw = true -- Do not update screen while doing batch changes. Show all matched, let narrow results, then let iterate through results.
vim.completeopt = "menuone,menu,longest,preview"
vim.opt.wildmenu = true
vim.opt.wildoptions = "fuzzy"
vim.opt.wildmode = "longest:full,full"
-- Show invisible characters.
vim.opt.list = true
vim.opt.listchars:append({
    tab = "· ",
    nbsp = "•",
    trail = "•",
    extends = "»",
    precedes = "«",
})
vim.opt.signcolumn = "yes" -- Always show the sign column (e.g. warnigns).
vim.opt.statusline = ""
    .. "%F%m%r" -- File name, was it modified?, readonly?
    .. "%=" -- Right align (each %= will get the same amount of spaces).
    .. " %Y" -- File type (e.g. LUA).
    .. " [FORMAT=%{&ff},%{&encoding}]" -- Line ending type & encoding
    .. " [CHAR=%03.3b/0x%02.2B]" -- Character encoding.
    .. " [COL=%v,LINE=%p%%]" -- Cursor position.
-- 24bit color mode, also uses `gui` instead of `cterm` part of :highlight.
vim.opt.termguicolors = true
vim.opt.background = "dark"

-------- Temporal files.
-- Use double // to use full path as swap/backup/undo file name.
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("config") .. "/tmp/undo/"

vim.opt.swapfile = true
vim.opt.directory = vim.fn.stdpath("config") .. "/tmp/swap//" -- hello

vim.opt.backup = true
vim.opt.backupext = ".bak"
vim.opt.backupdir = vim.fn.stdpath("config") .. "/tmp/backups//"
vim.opt.backupcopy = "yes" -- Make backup by copying original file.
-- Add a suffix that includes current seconds to all backups (higher chance to
-- restor anything).
vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("backups", { clear = true }),
    callback = function()
        vim.opt.backupext = "sec_" .. vim.fn.strftime("%S") .. ".bak"
    end,
})

-------- Search & Replace.
vim.opt.ignorecase = true -- Case insensetive search.
vim.opt.smartcase = true -- Unless capitals are use.
vim.opt.gdefault = true -- Assume global substitutions s///g by default.
-- Show match in the center of window (and open folds).
vim.keymap.set("n", "n", "nzzzR")
vim.keymap.set("n", "N", "NzzzR")

-------- Wrapping.
vim.opt.linebreak = true -- While wrapping lines, break at word boundaries only.
vim.opt.virtualedit = "all" -- Let cursor fly anythere.
-- Move by screen lines not by file.
vim.keymap.set({ "n", "x" }, "j", "gj", { desc = "Move one screen line down" })
vim.keymap.set({ "n", "x" }, "k", "gk", { desc = "Move one screen line up " })

-------- Indentation.
vim.opt.autoindent = true -- Copy indention level from the prev line.
vim.opt.smartindent = true -- Try your best to guess if indentation level needs to be changed (e.g. line after `{`).
vim.opt.shiftwidth = 4 -- Numbers of spaces to <> commands.
vim.opt.softtabstop = 4 -- If someone uses spaces delete them with backspace.
vim.opt.tabstop = 4 -- Numbers of spaces of tab character.
vim.opt.expandtab = true -- Use spaces instead of tab.
vim.opt.backspace = "indent,eol,start" -- Allow backspace over anything.

-------- Windows.
vim.keymap.set("n", "<c-w><s-j>", ":resize -2<cr>", { desc = "Decrease window height" })
vim.keymap.set("n", "<c-w><s-k>", ":resize +2<cr>", { desc = "Increased window height" })
vim.keymap.set("n", "<c-w><s-h>", ":vertical resize -2<cr>", { desc = "Decrease window width" })
vim.keymap.set("n", "<c-w><s-l>", ":vertical resize +2<cr>", { desc = "Increased window width" })

-------- Plugins.
local lazypath = vim.fn.stdpath("config") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup({
    {
        "rebelot/kanagawa.nvim",
        priority = 1000, -- Load first.
        config = function()
            vim.cmd.colorscheme("kanagawa")
        end,
    },

    {
        "tomtom/tcomment_vim",
        config = function()
            vim.keymap.set({ "n", "x" }, ",ci", ":TComment<cr>", { desc = "Toogle line comment" })
        end,
    },

    "Raimondi/delimitMate",

    {
        "vim-bbye",
        config = function()
            vim.cmd.cabbrev("bd Bdelete")
        end,
    },

    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            -- Allow multi key sequences to cancel after given amount of time.
            -- Cancelation will trigger which-key.
            vim.o.timeout = true
            vim.o.timeoutlen = 500
        end,
        config = function()
            require("which-key").setup()
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                -- Required fields, setting to unset to make Lua LSP happy.
                ensure_installed = {},
                sync_install = false,
                ignore_install = {},
                modules = {},
                -- Auto install treesitter parser on opening certain file type
                -- first time.
                auto_install = true,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                indent = { enable = true },
            })
        end,
    },

    -- After reopening vim, scroll to the previous cursor position.
    "farmergreg/vim-lastplace",

    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local builtin = require("telescope.builtin")
            vim.keymap.set("n", ",p", builtin.live_grep, { desc = "Live grep" })
        end,
    },

    {
        "NvChad/nvim-colorizer.lua",
        config = function()
            require("colorizer").setup({
                user_default_options = {
                    css = true,
                    mode = "virtualtext",
                },
            })
        end,
    },

    {
        -- Installs LSP servers, formatters, linters, etc.
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },

    -- LSP.
    {
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
                    keymap.set("n", ",lr", vim.lsp.buf.rename, opts)

                    opts.desc = "See available fixes"
                    keymap.set({ "n", "v" }, ",lf", vim.lsp.buf.code_action, opts)

                    opts.desc = "Show documentation for word under cursor"
                    keymap.set("n", ",lh", vim.lsp.buf.hover, opts)

                    opts.desc = "Restart LSP"
                    keymap.set("n", ",lR", ":LspRestart<CR>", opts)
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
    },

    -- Auto formatting.
    {
        "stevearc/conform.nvim",
        dependencies = {
            -- NOTE: Preconfigured separately.
            "williamboman/mason.nvim",
            -- Maps between linters installed by Mason and configurations managed
            -- by conform.
            "zapling/mason-conform.nvim",
        },
        config = function()
            require("conform").setup({
                formatters_by_ft = {
                    lua = { "stylua" },
                    cpp = { "clang_format" },
                    -- rust = handled by LSP.
                    sh = { "beautysh" },
                    python = { "isort", "black" },
                    javascript = { "prettier" },
                    typescript = { "prettier" },
                    css = { "prettier" },
                    html = { "prettier" },
                    json = { "prettier" },
                    yaml = { "prettier" },
                    markdown = { "prettier" },
                },
                format_on_save = {
                    lsp_fallback = true,
                    async = false,
                    timeout_ms = 1000,
                },
            })

            -- Has to be after `conform.setup`.
            require("mason-conform").setup()
        end,
    },

    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            -- Snippet engine, only using for completion purposes.
            "hrsh7th/cmp-vsnip",
            "hrsh7th/vim-vsnip",
        },
        config = function()
            local cmp = require("cmp")
            cmp.setup({
                snippet = {
                    expand = function(args)
                        vim.fn["vsnip#anonymous"](args.body)
                    end,
                },
                sources = cmp.config.sources(
                    -- Priority group 1.
                    {
                        { name = "nvim_lsp" },
                        { name = "path" },
                    },
                    -- Priority group 2.
                    {
                        { name = "buffer" },
                    }
                ),
                mapping = cmp.mapping.preset.insert({
                    ["<c-n>"] = cmp.mapping(cmp.mapping.select_next_item()),
                    ["<c-p>"] = cmp.mapping(cmp.mapping.select_prev_item()),
                    ["<cr>"] = cmp.mapping.confirm({ select = true }),
                }),
            })
        end,
    },
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "gitcommit",
    group = vim.api.nvim_create_augroup("ft_vcs", { clear = true }),
    callback = function()
        -- Autowrap at 80 characters.
        vim.opt_local.textwidth = 80
        vim.opt_local.formatoptions:append("t")
    end,
})
