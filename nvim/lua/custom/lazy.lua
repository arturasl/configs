local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup({
    spec = "custom.plugins",
    install = { colorscheme = { "kanagawa", "habamax" } },
    -- Do not notify after configuration changes, just reload silently.
    change_detection = { notify = false },
    -- Auto check for updates once a day.
    checker = {
        enabled = true,
        notify = true,
        frequency = 60 * 60 * 24,
    },
})
