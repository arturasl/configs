return {
    "moll/vim-bbye",
    config = function()
        vim.keymap.set("n", "<space>q", "<cmd>Bdelete<cr>", { desc = "Close current buffer" })
    end,
}
