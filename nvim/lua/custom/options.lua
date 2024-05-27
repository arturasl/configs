vim.g.mapleader = "\\" -- Never use true leader to prevent plugins from creating interfering key maps.
vim.opt.number = true -- Show number line.
vim.opt.mouse = "a" -- More mouse please :)
vim.opt.colorcolumn = "81" -- Column list to highlight (now only 80).
vim.opt.scrolloff = 10 -- Try to show at least num lines.
vim.opt.autochdir = true -- File commands are relative to cur directory.
vim.opt.shell = "bash" -- Always use bash as shell for vim.
vim.opt.fileformats = "unix,dos,mac" -- Use \n for new lines by default (unless file uses \r\n or \r).
vim.opt.fileencodings = "ucs-bom,utf-8,latin1" -- Encodings to try for existing files (for new one - UTF-8).
vim.opt.lazyredraw = true -- Do not update screen while doing batch changes.
-- Show all matched, let narrow results, then let iterate through results.
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
vim.opt.signcolumn = "yes" -- Always show the sign column (e.g. warnings).
vim.opt.statusline = ""
    .. "%F%m%r" -- File name, was it modified?, read-only?
    .. "%=" -- Right align (each %= will get the same amount of spaces).
    .. " %Y" -- File type (e.g. LUA).
    .. " [FORMAT=%{&ff},%{&encoding}]" -- Line ending type & encoding
    .. " [CHAR=%03.3b/0x%02.2B]" -- Character encoding.
    .. " [COL=%v,LINE=%p%%]" -- Cursor position.
-- 24bit color mode, also uses `gui` instead of `cterm` part of :highlight.
vim.opt.termguicolors = true
vim.opt.background = "dark"
-- view:
--   Try to restore screen position before the jump happened.
-- stack:
--   Assuming jumps:
--     a -> b -> c -> d
--   Jumping back twice:
--     a -> [b] -> c -> d
--   Jumping to e (normal behaviour):
--     a -> b -> c -> d -> e
--   Stacking behaviour:
--     a -> b -> e
vim.opt.jumpoptions = { "stack", "view" }

-- Highlight current line in active window only.
vim.opt.cursorline = true
vim.api.nvim_create_autocmd({ "VimEnter", "WinEnter", "BufWinEnter" }, {
    group = vim.api.nvim_create_augroup("set_cursor_line", { clear = true }),
    callback = function()
        vim.opt_local.cursorlineopt = "both" -- Highlight line number and screen line.
    end,
})
vim.api.nvim_create_autocmd("WinLeave", {
    group = vim.api.nvim_create_augroup("clear_cursor_line", { clear = true }),
    callback = function()
        vim.opt_local.cursorlineopt = "number" -- Highlight line number.
    end,
})

-------- Temporal files.
-- Use double // to use full path as swap/backup/undo file name.
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("config") .. "/tmp/undo/"

vim.opt.swapfile = true
vim.opt.directory = vim.fn.stdpath("config") .. "/tmp/swap//"

vim.opt.backup = true
vim.opt.backupext = ".bak"
vim.opt.backupdir = vim.fn.stdpath("config") .. "/tmp/backups//"
vim.opt.backupcopy = "yes" -- Make backup by copying original file.
-- Add a suffix that includes current seconds to all backups (higher chance to
-- restore anything).
vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("backups", { clear = true }),
    callback = function()
        vim.opt.backupext = ".sec_" .. vim.fn.strftime("%S") .. ".bak"
    end,
})

-- Use spell check for English and Lithuanian languages.
vim.opt.spelllang = { "en", "lt" }
vim.opt.spell = true

-------- Search & Replace.
vim.opt.ignorecase = true -- Case insensitive search.
vim.opt.smartcase = true -- Unless capitals are use.
vim.opt.gdefault = true -- Assume global substitutions s///g by default.
-- Show match in the center of window (and open folds).
vim.keymap.set("n", "n", "nzzzR")
vim.keymap.set("n", "N", "NzzzR")

-------- Wrapping.
vim.opt.linebreak = true -- While wrapping lines, break at word boundaries only.
vim.opt.virtualedit = "all" -- Let cursor fly anywhere.
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
vim.keymap.set("n", "<c-w><s-j>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
vim.keymap.set("n", "<c-w><s-k>", "<cmd>resize +2<cr>", { desc = "Increased window height" })
vim.keymap.set("n", "<c-w><s-h>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
vim.keymap.set("n", "<c-w><s-l>", "<cmd>vertical resize +2<cr>", { desc = "Increased window width" })

-------- Building & Quickfix.
vim.keymap.set("n", "<space>br", ":make run<cr>", { desc = "Run" })
vim.keymap.set("n", "<space>be", require("custom/functions").toogle_quick_fix, { desc = "Quickfix toogle" })
vim.keymap.set("n", "<space>bn", "<cmd>cnext<cr>", { desc = "Quickfix next" })
vim.keymap.set("n", "<space>bp", "<cmd>cprev<cr>", { desc = "Quickfix previous" })

-------- Commenting.
vim.keymap.set("n", "<space>c", function()
    require("custom/functions").preserve_cursor("gcc")
end, { desc = "Toogle comment on current line" })
vim.keymap.set("x", "<space>c", function()
    require("custom/functions").preserve_cursor("gc")
end, { desc = "Toogle comment on selected lines" })
