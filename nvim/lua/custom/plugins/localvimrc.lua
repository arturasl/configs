return {
    "embear/vim-localvimrc",
    init = function()
        -- Note that name is different from this file in order not to mess
        -- with require("custom/functions").find_root().
        vim.g.localvimrc_name = "local_vimrc.lua"
        vim.g.localvimrc_reverse = 1 -- Source files starting from current directory.
        vim.g.localvimrc_ask = 0
        vim.g.localvimrc_sandbox = 0
    end,
}
