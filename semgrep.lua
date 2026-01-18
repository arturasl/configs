-- To run use:
--   semgrep scan --test --config semgrep.yaml semgrep.lua
local vim = {}

-- ruleid: avoid-vim-o
vim.o.relativenumber = true

-- ok: avoid-vim-o
vim.opt.relativenumber = true

-- ruleid: always-include-auto-group-name
vim.api.nvim_create_autocmd("FileType", {
	callback = function() end,
})

-- ok: always-include-auto-group-name
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("treesitter_init", { clear = true }),
})

-- ruleid: use-dot-for-modules
require("a/b/c")
--
-- ok: use-dot-for-modules
require("a.b.c")
