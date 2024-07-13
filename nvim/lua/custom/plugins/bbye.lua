return {
    "moll/vim-bbye",
    config = function()
        vim.keymap.set("n", "<space>q", "<cmd>Bdelete<cr>", { desc = "Buffer [Q]uit (bbye)" })
    end,
}
