return {
    "tomtom/tcomment_vim",
    config = function()
        vim.keymap.set({ "n", "x" }, ",ci", ":TComment<cr>", { desc = "Toogle line comment" })
    end,
}
