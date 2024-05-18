return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        local builtin = require("telescope.builtin")

        vim.keymap.set("n", ",ff", function()
            builtin.find_files({ cwd = require("custom/functions").find_root() })
        end, { desc = "Find files" })

        vim.keymap.set("n", ",fg", function()
            builtin.live_grep({ cwd = require("custom/functions").find_root() })
        end, { desc = "Live grep" })

        vim.keymap.set("n", ",fh", builtin.oldfiles, { desc = "Previous files" })
    end,
}
