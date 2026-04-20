local alternative_file_picker = function()
    local cur_file = vim.fn.fnamemodify(vim.fn.bufname("%"), ":p")
    local options = {}

    local insert_if_alternate = function(pattern, replacement)
        local new_file = pattern
        if replacement ~= nil then
            new_file = cur_file:gsub(pattern, replacement)
        end

        if new_file == cur_file then
            return
        end
        if vim.fn.filereadable(new_file) == 0 then
            return
        end
        options[#options + 1] = new_file
    end

    -- Clojure
    insert_if_alternate("^(.*)/src/(.*)%.clj", "%1/test/%2_test.clj")
    insert_if_alternate("^(.*)/test/(.*)%_test.clj", "%1/src/%2.clj")

    -- Cpp.
    local wo_cpp_suffix =
        cur_file:gsub("%.cpp$", ""):gsub("%.cc$", ""):gsub("%.h$", ""):gsub("%.hpp$", ""):gsub("_test$", "")
    for _, suffix in ipairs({ ".cpp", ".cc", "_test.cpp", "_test.cc", ".h", ".hpp" }) do
        insert_if_alternate(wo_cpp_suffix .. suffix)
    end

    -- Python.
    local wo_py_suffix = cur_file:gsub("%.py$", ""):gsub("_test$", "")
    for _, suffix in ipairs({ ".py", "_test.py" }) do
        insert_if_alternate(wo_py_suffix .. suffix)
    end

    local option_to_abs = {}
    for _, abs_path in ipairs(options) do
        option_to_abs[vim.fn.fnamemodify(abs_path, ":t")] = abs_path
    end

    require("custom.functions").pick_file(vim.tbl_keys(option_to_abs), function(selection)
        local escaped = vim.fn.fnameescape(option_to_abs[selection])
        vim.cmd("edit " .. escaped)
    end)
end

local search_picker = function()
    local conf = require("telescope.config").values
    local finders = require("telescope.finders")
    local functions = require("custom.functions")
    local make_entry = require("telescope.make_entry")
    local pickers = require("telescope.pickers")
    local sorters = require("telescope.sorters")

    local finder = finders.new_async_job({
        command_generator = function(prompt)
            local parts = functions.tokinize(prompt or "")
            if #parts == 0 then
                return nil
            end

            local name_args = { "find", "." }
            vim.list_extend(name_args, { "-regextype", "posix-extended" })
            -- Do no go into hidden directories.
            vim.list_extend(name_args, { "(", "-type", "d", "-name", ".*", "!", "-name", ".", "-prune", ")" })

            -- Ignore some file extensions.
            vim.list_extend(name_args, { "-o", "(", "-false" })
            for _, ignore in ipairs({ "*.zip", "*.gz", "*.tar", "*.pdf", "*.png", "*.jpeg" }) do
                vim.list_extend(name_args, { "-o", "-name", ignore })
            end
            vim.list_extend(name_args, { "-prune", ")" })

            -- Search for files.
            vim.list_extend(name_args, { "-o", "-type", "f" })
            local had_name = false

            local contents_args = {
                "rg",
                "--color=never",
                "--no-heading",
                "--with-filename",
                "--line-number",
                "--column",
                "--smart-case",
            }
            local had_contents = false

            for _, p in ipairs(parts) do
                local after_colon = p:match(":(.*)") or p

                if p:find("^f:") then
                    vim.list_extend(name_args, { "-and", "-iregex", ".*(" .. after_colon .. ").*" })
                    had_name = true
                elseif p:find("^-f:") then
                    vim.list_extend(name_args, { "-and", "-not", "-iregex", ".*(" .. after_colon .. ").*" })
                    had_name = true
                else
                    table.insert(contents_args, "--regexp=" .. p)
                    had_contents = true
                end
            end

            if not had_contents then
                vim.list_extend(name_args, { "-printf", "%p:1:1:\\n" })
            elseif not had_name then
                name_args = contents_args
            else
                vim.list_extend(name_args, { "-exec" })
                vim.list_extend(name_args, contents_args)
                vim.list_extend(name_args, { "{}", "+" })
            end

            return name_args
        end,
        entry_maker = make_entry.gen_from_vimgrep({}),
        cwd = functions.find_root(),
    })

    pickers
        .new({}, {
            prompt_title = "Search",
            debounce = 200,
            finder = finder,
            previewer = conf.grep_previewer({}),
            sorter = sorters.empty(),
        })
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

        vim.keymap.set("n", "<space>ss", search_picker, { desc = "[S]earch files" })
        vim.keymap.set("n", "<space>a", alternative_file_picker, { desc = "[A]lternative file" })
        vim.keymap.set("n", "<space>sh", builtin.oldfiles, { desc = "[H]istoric files" })
    end,
}
