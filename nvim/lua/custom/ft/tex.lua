vim.api.nvim_create_autocmd("FileType", {
    pattern = { "tex" },
    group = vim.api.nvim_create_augroup("ft_tex", { clear = true }),
    callback = function()
        vim.opt_local.makeprg = "pdflatex"
            .. " -shell-escape"
            .. " -file-line-error"
            .. " -interaction=nonstopmode"
            .. " '%'"
            .. " \\| grep '.*:[0-9]*:.*'"
        vim.opt_local.errorformat = "%f:%l: %m"
    end,
})

vim.api.nvim_create_autocmd("QuickFixCmdPost", {
    pattern = { "make" },
    group = vim.api.nvim_create_augroup("ft_tex_qf", { clear = true }),
    callback = function()
        if vim.bo.filetype ~= "tex" then
            return
        end
        vim.cmd("silent !~/configs/scripts/showme.bash --silent-detached %:r.pdf &>/dev/null &")
    end,
})
