vim.opt.number = true         -- Show number line.
vim.opt.mouse = 'a'           -- More mouse please :)
vim.opt.cursorline = true     -- Highlight current line.
vim.opt.colorcolumn='81'      -- Column list to highligh (now only 80).
vim.opt.scrolloff = 10        -- Try to show atleast num lines.
vim.opt.autochdir = true      -- File commands are relative to cur directory.
vim.opt.shell = 'bash'        -- Always use bash as shell for vim.
vim.opt.fileformats = 'unix,dos,mac' -- Use \n for new lines by default (unless
                                     -- file uses \r\n or \r).
vim.opt.fileencodings = 'ucs-bom,utf-8,latin1' -- Encodings to try for existing
                                               -- files (for new one - utf-8).
vim.opt.lazyredraw = true     -- Do not update screen while doing batch changes.
-- Show all matched, let narrow results, then let iterate through results.
vim.opt.wildmenu = true
vim.completeopt = 'menuone,menu,longest,preview'
vim.opt.wildmode = 'list:full,full'
-- Show invisible characters.
vim.opt.list = true
vim.opt.listchars:append {
    tab = "· ",
    nbsp = '•',
    trail = '•',
    extends = '»',
    precedes = '«',
}
vim.opt.signcolumn = 'yes'    -- Always show the sign column (e.g. warnigns).
vim.opt.statusline = ''..
  '%F%m%r'.. -- File name, was it modified?, readonly?
  '%='..     -- Right align (each %= will get the same amount of spaces).
  ' %Y'..    -- File type (e.g. LUA).
  ' [FORMAT=%{&ff},%{&encoding}]'.. -- Line ending type & encoding
  ' [CHAR=%03.3b/0x%02.2B]'..       -- Character encoding.
  ' [COL=%v,LINE=%p%%]'             -- Cursor position.
vim.cmd.colorscheme 'habamax'

-------- Temporal files.
-- Use double // to use full path as swap/backup/undo file name.
vim.opt.undofile = true
vim.opt.undodir = '~/.vim/tmp/undo/'

vim.opt.swapfile = true
vim.opt.directory = '~/.vim/tmp/swap//'

vim.opt.backup = true
vim.opt.backupext = '.bak'
vim.opt.backupdir = '~/.vim/tmp/backups//'
vim.opt.backupcopy = 'yes'    -- Make backup by copying original file.

-------- Search & Replace.
vim.opt.ignorecase = true     -- Case insensetive search.
vim.opt.smartcase = true      -- Unless capitals are use.
-- Show match in the center of window (and open folds).
vim.keymap.set('n', 'n', 'nzzzR')
vim.keymap.set('n', 'N', 'NzzzR')

-------- Wrapping.
vim.opt.linebreak = true      -- While wrapping lines, break at word boundaries only.
vim.opt.virtualedit = 'all'   -- Let cursor fly anythere.
-- Move by screen lines not by file.
vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('x', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')
vim.keymap.set('x', 'k', 'gk')

-------- Indentation.
vim.opt.autoindent = true     -- Copy indention level from the prev line.
vim.opt.smartindent = true    -- Try your best to guess if indentation level
                              -- needs to be changed (e.g. line after `{`).
vim.opt.shiftwidth = 4        -- Numbers of spaces to <> commands.
vim.opt.softtabstop = 4       -- If someone uses spaces delete them with backspace.
vim.opt.tabstop = 4           -- Numbers of spaces of tab character.
vim.opt.expandtab = true      -- Use spaces instead of tab.
vim.opt.backspace = 'indent,eol,start' -- Allow backspace over anything.

-------- Windows.
vim.keymap.set('n', '<c-w><s-j>', ':resize -2<cr>')
vim.keymap.set('n', '<c-w><s-k>', ':resize +2<cr>')
vim.keymap.set('n', '<c-w><s-h>', '2<c-w><')
vim.keymap.set('n', '<c-w><s-l>', '2<c-w>>')

-------- Plugins.
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end
vim.opt.rtp:prepend(lazypath)
require('lazy').setup({
    {
        'tomtom/tcomment_vim',
        init = function()
            vim.keymap.set('n', ',ci', ':TComment<cr>')
            vim.keymap.set('x', ',ci', ':TComment<cr>')
        end
    },
    'Raimondi/delimitMate',
    {
        'vim-bbye',
        init = function()
            vim.cmd.cabbrev 'bd Bdelete'
        end
    },
    'farmergreg/vim-lastplace',
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        opts = {
            auto_install = true, -- Auto install parsers for newly observed languages.
            highlight = {
                enable = true,
            },
            indent = { enable = true },
            config = function(_, opts)
                require('nvim-treesitter.install').prefer_git = true
                require('nvim-treesitter.configs').setup(opts)
            end,
        }
    },
})
