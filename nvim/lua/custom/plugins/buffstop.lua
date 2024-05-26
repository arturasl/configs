return {
    "mihaifm/bufstop",
    init = function()
        vim.g.BufstopKeys = "asdfghjkl"
    end,
    config = function()
        vim.keymap.set("n", "<space>v", "<cmd>BufstopModeFast<cr>")
    end,
}
