return {
    {
        "mhinz/vim-signify",
        event = { "BufReadPre" },
        init = function()
            vim.g.signify_sign_add = "▎"
            vim.g.signify_sign_delete = "▎"
            vim.g.signify_sign_delete_first_line = "▎"
            vim.g.signify_sign_change = "▎"

            vim.g.signify_vcs_cmds = {
                jj = "jj diff --color=never --context=0 -r @ -- %f",
            }

            vim.keymap.set("n", "<space>dn", "<plug>(signify-next-hunk)", { desc = "[D]iff [N]ext" })
            vim.keymap.set("n", "<space>dp", "<plug>(signify-prev-hunk)", { desc = "[D]iff [P]reviuos" })
            vim.keymap.set("n", "<space>dd", "<cmd>:SignifyDiff!<cr>", { desc = "[D]iff" })
        end,
    },

    {
        "mbbill/undotree",
        keys = {
            { "<space>dl", vim.cmd.UndotreeToggle, desc = "[D]iff [L]ocal" },
        },
    },

    {
        "rafikdraoui/jj-diffconflicts",
        cmd = "JJDiffConflicts",
        init = function()
            vim.g.jj_diffconflicts_show_usage_message = false
        end,
    },
}
