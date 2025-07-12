return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")
        local builtin = require("telescope.builtin")

        telescope.setup({
            defaults = {
                mappings = {
                    i = {
                        ["<C-b>"] = actions.preview_scrolling_up,
                        ["<C-f>"] = actions.preview_scrolling_down,
                    },
                    n = {
                        ["<C-b>"] = actions.preview_scrolling_up,
                        ["<C-f>"] = actions.preview_scrolling_down,
                    },
                },
            },
        })

        vim.keymap.set("n", "<space>ss", function()
            builtin.find_files({ cwd = require("custom/functions").find_root() })
        end, { desc = "Find files" })

        vim.keymap.set("n", "<space>sg", function()
            builtin.live_grep({ cwd = require("custom/functions").find_root() })
        end, { desc = "Live [G]rep" })

        vim.keymap.set("n", "<space>sh", builtin.oldfiles, { desc = "[H]istoric files" })
    end,
}
