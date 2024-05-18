local lazypath = vim.fn.stdpath("config") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup({
    spec = "custom.plugins",
    install = { colorscheme = { "kanagawa", "habamax" } },
    change_detection = { notify = false },
})
