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

    local opts = {
        cwd = functions.find_root(),
    }

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
        entry_maker = make_entry.gen_from_vimgrep(opts),
        cwd = opts.cwd,
    })

    pickers
        .new({}, {
            prompt_title = "Search",
            debounce = 200,
            finder = finder,
            previewer = conf.grep_previewer(opts),
            sorter = sorters.empty(),
        })
        :find()
end

local vcs_changed_files_picker = function()
    local remove_non_existing = function(files)
        return vim.tbl_filter(function(file)
            return vim.fn.filereadable(file) == 1
        end, files)
    end

    local run = function(args, stdin)
        local lines = vim.fn.systemlist(args, stdin)
        if vim.v.shell_error ~= 0 then
            return {}
        end
        return lines
    end

    local files = {}
    vim.list_extend(files, run({ "jj", "diff", "--name-only" }))

    local svn_root = vim.trim(run({ "svn", "info", "--show-item", "wc-root" })[1] or "")
    if svn_root ~= "" then
        local svn_modified = run({ "svn", "status", svn_root })
        vim.list_extend(files, run({ "awk", "{print $2}" }, svn_modified))
    end

    local git_modified = run({ "git", "status", "--short" })
    if #git_modified > 0 then
        vim.list_extend(files, run({ "awk", "{print $2}" }, git_modified))
    end

    vim.print(files)

    require("custom.functions").pick_file(remove_non_existing(files), function(selected)
        local escaped = vim.fn.fnameescape(selected)
        vim.cmd("edit " .. escaped)
    end)
end

return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
    },
    keys = {
        -- Search.
        { "<space>ss", search_picker, desc = "[S]earch files" },
        { "<space>sc", vcs_changed_files_picker, desc = "[S]earch [C]hanged files" },
        {
            "<space>sh",
            function()
                require("telescope.builtin").oldfiles()
            end,
            desc = "[S]earch [H]istoric files",
        },

        -- Alternatives.
        { "<space>a", alternative_file_picker, desc = "[A]lternative file" },

        -- Lsp.
        {
            "<space>lu",
            function()
                require("telescope.builtin").lsp_references()
            end,
            desc = "[Lsp] [U]sages (references)",
        },
        {
            "<space>ld",
            function()
                require("telescope.builtin").diagnostics({ bufnr = 0 })
            end,
            desc = "[L]sp [D]iagnostics",
        },
    },
    config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")

        local mappings = {
            ["<C-y>"] = actions.select_default,
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
    end,
}
