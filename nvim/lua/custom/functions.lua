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
        local root_files = { "Cargo.toml", ".git", ".svn" }
        for _, root_file in ipairs(root_files) do
            local found = ""
            if found == "" then
                found = vim.fn.findfile(root_file, ".;") or ""
            end
            if found == "" then
                found = vim.fn.finddir(root_file, ".;") or ""
            end
            if found ~= "" then
                return vim.fs.dirname(found)
            end
        end

        return vim.fn.expand("%:p:h")
    end,
}
