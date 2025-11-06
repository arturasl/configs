return {
    {
        "mhinz/vim-signify",
        event = { "BufReadPre" },
        init = function()
            vim.g.signify_sign_add = "▎"
            vim.g.signify_sign_delete = "▎"
            vim.g.signify_sign_delete_first_line = "▎"
            vim.g.signify_sign_change = "▎"
        end,
    },

    {
        "rafikdraoui/jj-diffconflicts",
        cmd = "JJDiffConflicts",
        init = function()
            vim.g.jj_diffconflicts_show_usage_message = false
        end,
    },
}
