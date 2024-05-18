return {
    "embear/vim-localvimrc",
    init = function()
        vim.g.localvimrc_name = "localvimrc.lua"
        vim.g.localvimrc_reverse = 1 -- Source files starting from current dir.
        vim.g.localvimrc_ask = 0
        vim.g.localvimrc_sandbox = 0
    end,
}
