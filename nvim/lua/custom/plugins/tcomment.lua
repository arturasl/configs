return {
    "tomtom/tcomment_vim",
    config = function()
        vim.keymap.set({ "n", "x" }, "<space>ci", ":TComment<cr>", { desc = "Toogle line comment" })
    end,
}
