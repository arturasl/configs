return {
    dir = "~/.vim/bundle/Spelling/",
    config = function()
        -- Use spell check for English and Lithuanian languages.
        vim.opt.spelllang = { "en", "lt" }
        vim.opt.spell = true
    end,
}
