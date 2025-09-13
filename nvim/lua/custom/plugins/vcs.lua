return {
    {
        "mhinz/vim-signify",
    },
    {
        "rafikdraoui/jj-diffconflicts",
        config = function()
            vim.g.jj_diffconflicts_show_usage_message = false
        end,
    },
}
