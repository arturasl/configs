return {
    toogle_quick_fix = function()
        local exists = false
        for _, win in pairs(vim.fn.getwininfo()) do
            if win["quickfix"] == 1 then
                exists = true
                break
            end
        end

        if exists == true then
            vim.cmd("cclose")
        else
            vim.cmd("copen")
        end
    end,

    open_quick_fix_if_not_empty = function()
        if not vim.tbl_isempty(vim.fn.getqflist()) then
            vim.cmd("copen")
        else
            vim.cmd("cclose")
        end
    end,

    find_root = function()
        local found = vim.fs.root(vim.fn.getcwd(), { "Cargo.toml", ".git", ".svn" })
        if found then
            return found
        end

        return vim.fn.expand("%:p:h")
    end,

    preserve_cursor = function(arg)
        local tabnr = 0 -- Current.
        local winnr = vim.api.nvim_get_current_win()
        local line, col = unpack(vim.api.nvim_win_get_cursor(winnr))

        if type(arg) == "string" then
            vim.cmd.normal(arg)
        else
            arg()
        end

        vim.api.nvim_tabpage_set_win(tabnr, winnr)
        -- Min between total line count in current buffer in case it changed.
        line = math.min(vim.fn.line("$"), line)
        vim.api.nvim_win_set_cursor(winnr, { line, col })
        vim.cmd([[stopinsert]])
    end,
}
