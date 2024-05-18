return {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local builtin = require("telescope.builtin")
        vim.keymap.set("n", ",ff", builtin.live_grep, { desc = "Live grep" })
        vim.keymap.set("n", ",fh", builtin.oldfiles, { desc = "Previous files" })
    end,
}
