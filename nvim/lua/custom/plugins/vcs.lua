local toggle_diff = function()
    local diff_win = -1
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t") == "diff" then
            diff_win = win
        end
    end

    if diff_win ~= -1 then
        vim.api.nvim_win_close(diff_win, true)
        return
    end

    require("custom.functions").preserve_cursor(function()
        vim.cmd("SignifyDiff!")
    end)
    vim.schedule(function()
        vim.cmd("wincmd R") -- Rotate. Makes (diff to be on right).
        vim.cmd("wincmd l") -- Jump to diff window.
        vim.api.nvim_buf_set_name(0, "diff")
        vim.cmd("wincmd h") -- Jump back to original window.
    end)
end

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
            vim.keymap.set("n", "<space>dd", toggle_diff, { desc = "[D]iff" })
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
