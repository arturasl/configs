vim.api.nvim_create_autocmd("FileType", {
    pattern = { "dot" },
    group = vim.api.nvim_create_augroup("ft_dot", { clear = true }),
    callback = function()
        vim.opt_local.makeprg = "dot '%' -Tpng -O"
        vim.opt_local.errorformat = "%f:%l: %m"
    end,
})

vim.api.nvim_create_autocmd("QuickFixCmdPost", {
    pattern = { "make" },
    group = vim.api.nvim_create_augroup("ft_dot_qf", { clear = true }),
    callback = function()
        if vim.bo.filetype ~= "dot" then
            return
        end
        vim.cmd("silent !~/configs/scripts/showme.bash --silent-detached %.png &>/dev/null &")
    end,
})
