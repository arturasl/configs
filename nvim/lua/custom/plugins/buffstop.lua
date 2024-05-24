return {
    "mihaifm/bufstop",
    init = function()
        vim.g.BufstopKeys = "asdfghjkl"
    end,
    config = function()
        vim.keymap.set("n", "<space>c", "<cmd>BufstopModeFast<cr>")
    end,
}
