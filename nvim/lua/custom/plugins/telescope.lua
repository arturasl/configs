local alternative_file_picker = function()
    local cur_file = vim.fn.fnamemodify(vim.fn.bufname("%"), ":p")
    local options = {}

    local insert_if_alternate = function(pattern, replacement)
        local new_file = cur_file:gsub(pattern, replacement)
        if new_file == cur_file then
            return
        end
        if not vim.fn.filereadable(new_file) then
            return
        end
        options[#options + 1] = new_file
    end

    if vim.endswith(cur_file, ".clj") then
        insert_if_alternate("^(.*)/src/(.*)%.clj", "%1/test/%2_test.clj")
        insert_if_alternate("^(.*)/test/(.*)%_test.clj", "%1/src/%2.clj")
    end

    local option_to_abs = {}
    for _, abs_path in ipairs(options) do
        option_to_abs[vim.fn.fnamemodify(abs_path, ":t")] = abs_path
    end

    require("telescope.pickers")
        .new(
            require("telescope.themes").get_dropdown({
                initial_mode = "normal",
                layout_config = { height = 10 },
            }),
            {
                finder = require("telescope.finders").new_table({
                    results = vim.tbl_keys(option_to_abs),
                }),
                attach_mappings = function(bufnr, _)
                    local actions = require("telescope.actions")
                    local action_state = require("telescope.actions.state")
                    actions.select_default:replace(function()
                        actions.close(bufnr)
                        local selection = action_state.get_selected_entry()[1]
                        local escaped = vim.fn.fnameescape(option_to_abs[selection])
                        vim.cmd("edit " .. escaped)
                    end)
                    return true
                end,
            }
        )
        :find()
end

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

        local mappings = {
            ["<C-b>"] = actions.preview_scrolling_up,
            ["<C-f>"] = actions.preview_scrolling_down,
            ["<C-n>"] = actions.move_selection_next,
            ["<C-p>"] = actions.move_selection_previous,
            ["<Up>"] = actions.cycle_history_prev,
            ["<Down>"] = actions.cycle_history_next,
        }
        telescope.setup({
            defaults = {
                mappings = {
                    i = mappings,
                    n = mappings,
                },
            },
        })

        vim.keymap.set("n", "<space>a", alternative_file_picker, { desc = "[A]lternative file" })

        vim.keymap.set("n", "<space>ss", function()
            builtin.find_files({ cwd = require("custom/functions").find_root() })
        end, { desc = "Find files" })

        vim.keymap.set("n", "<space>sg", function()
            builtin.live_grep({ cwd = require("custom/functions").find_root() })
        end, { desc = "Live [G]rep" })

        vim.keymap.set("n", "<space>sh", builtin.oldfiles, { desc = "[H]istoric files" })
    end,
}
