return {
    "mbbill/undotree",
    config = function()
        vim.keymap.set("n", "<down>", vim.cmd.UndotreeToggle, { desc = "Toogle UndoTree" })
    end,
}
