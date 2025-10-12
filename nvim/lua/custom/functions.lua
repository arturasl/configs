return {
    toogle_quick_fix = function()
        for _, win in pairs(vim.fn.getwininfo()) do
            if win["quickfix"] == 1 then
                vim.cmd("cclose")
                return
            end
        end

        vim.cmd("botright copen")
    end,

    find_root = function()
        local found = vim.fs.root(vim.fn.getcwd(), { "Cargo.toml", ".git", ".svn", "local_vimrc.lua" })
        if found then
            return found
        end

        return vim.fn.expand("%:p:h")
    end,

    preserve_cursor = function(arg)
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
    end,

    visible_buffer_nrs = function()
        local bufs = {}
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            bufs[vim.api.nvim_win_get_buf(win)] = true
        end
        return vim.tbl_keys(bufs)
    end,
}
