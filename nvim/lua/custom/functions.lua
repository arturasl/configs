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
}
