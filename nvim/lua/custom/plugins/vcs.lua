return {
    {
        "mhinz/vim-signify",
        event = "VeryLazy",
    },

    {
        "rafikdraoui/jj-diffconflicts",
        cmd = "JJDiffConflicts",
        init = function()
            vim.g.jj_diffconflicts_show_usage_message = false
        end,
    },
}
