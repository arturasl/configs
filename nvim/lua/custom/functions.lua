local M = {}

local get_window_height = function(type)
    for _, win in pairs(vim.fn.getwininfo()) do
        if win[type] == 1 then
            return win.height
        end
    end
    return 0
end

local previous_cmd = nil
M.run_cmd_on_key = function(options)
    options = vim.tbl_extend(
        "keep",
        options,
        { keys = nil, fn_cmd = nil, onsuccess = nil, desc = nil, pipe_first_known_file = nil }
    )
    assert(options.keys)
    assert(options.desc)
    assert(options.fn_cmd)

    vim.keymap.set("n", options.keys, function()
        local cmd = ""
        -- Note that cmd is delayed so that vim.fn.expand() would happen after
        -- keymap.
        for _, val in ipairs(options.fn_cmd()) do
            cmd = cmd .. vim.fn.shellescape(val) .. " "
        end
        if options.pipe_first_known_file ~= nil then
            for _, known_file in ipairs(options.pipe_first_known_file) do
                if vim.uv.fs_stat(known_file) then
                    cmd = cmd .. "<"
                    cmd = cmd .. vim.fn.shellescape(known_file)
                    break
                end
            end
        end

        M.preserve_cursor(function()
            -- Preserve quickfix and/or terminal window height if it is opened.
            local orig_height = math.max( --
                get_window_height("quickfix"),
                get_window_height("terminal")
            )

            -- Close quickfix.
            vim.cmd.cclose()
            -- Close terminal.
            if previous_cmd ~= nil then
                vim.fn.jobstop(previous_cmd.job_id)
                if vim.api.nvim_buf_is_valid(previous_cmd.buf_id) then
                    vim.api.nvim_buf_delete(previous_cmd.buf_id, { force = true })
                end
            end

            -- botright -- open at the bottom below any other windows at
            -- occupying full width (e.g. if already have split view).
            vim.cmd("botright " .. (orig_height ~= 0 and orig_height or 20) .. "split")

            local buf_id = vim.api.nvim_create_buf(
                false, --listed
                true --scratch
            )
            vim.api.nvim_set_current_buf(buf_id)

            local job_id = vim.fn.jobstart(cmd, {
                term = true,
                on_exit = function(_, exit_code, _)
                    if exit_code == 0 and options.onsuccess ~= nil then
                        options.onsuccess()
                    end
                end,
            })

            -- Auto scroll down.
            vim.cmd("normal! G")

            previous_cmd = {
                buf_id = buf_id,
                job_id = job_id,
            }
        end)
    end, { desc = options.desc, buffer = true })
end

M.toogle_quick_fix = function()
    for _, win in pairs(vim.fn.getwininfo()) do
        if win["quickfix"] == 1 then
            vim.cmd("cclose")
            return
        end
    end

    vim.cmd("botright copen")
end

M.find_root = function()
    local found = vim.fs.root(vim.fn.getcwd(), { "Cargo.toml", ".git", ".svn", "local_vimrc.lua", "project.clj" })
    if found then
        return found
    end

    return vim.fn.expand("%:p:h")
end

M.preserve_cursor = function(arg)
    local tabnr = vim.api.nvim_get_current_tabpage()
    local winnr = vim.api.nvim_get_current_win()
    local line, col = unpack(vim.api.nvim_win_get_cursor(winnr))

    if type(arg) == "string" then
        vim.cmd.normal(arg)
    else
        arg()
    end

    vim.api.nvim_set_current_tabpage(tabnr)
    vim.api.nvim_tabpage_set_win(tabnr, winnr)
    -- Min between total line count in current buffer in case it changed.
    line = math.min(vim.fn.line("$"), line)
    vim.api.nvim_win_set_cursor(winnr, { line, col })
    vim.cmd("stopinsert")
end

M.visible_buffer_nrs = function()
    local bufs = {}
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        bufs[vim.api.nvim_win_get_buf(win)] = true
    end
    return vim.tbl_keys(bufs)
end

local lazy_core = require("lazy.core.config")
M.is_plugin_loaded = function(name)
    return vim.tbl_get(lazy_core, "plugins", name, "_", "loaded")
end

return M
