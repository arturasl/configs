return {
    {
        "mhinz/vim-signify",
    },
    {
        "rafikdraoui/jj-diffconflicts",
        init = function()
            vim.g.jj_diffconflicts_show_usage_message = false
        end,
    },
}
