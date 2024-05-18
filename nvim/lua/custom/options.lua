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

-------- Building.
vim.keymap.set("n", ",bb", function()
    vim.cmd("make")
    require("custom/functions").open_quick_fix_if_not_empty()
end, { desc = "Build" })
vim.keymap.set("n", ",be", function()
    require("custom/functions").toogle_quick_fix()
end, { desc = "Show errors" })
vim.keymap.set("n", ",br", ":make run<cr>", { desc = "Run" })
