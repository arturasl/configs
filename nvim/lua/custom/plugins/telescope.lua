return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        local builtin = require("telescope.builtin")

        vim.keymap.set("n", "<space>ss", function()
            builtin.find_files({ cwd = require("custom/functions").find_root() })
        end, { desc = "Find files" })

        vim.keymap.set("n", "<space>sg", function()
            builtin.live_grep({ cwd = require("custom/functions").find_root() })
        end, { desc = "Live grep" })

        vim.keymap.set("n", "<space>sh", builtin.oldfiles, { desc = "Previous files" })
    end,
}
