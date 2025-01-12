vim.api.nvim_create_autocmd("FileType", {
    pattern = { "cpp" },
    group = vim.api.nvim_create_augroup("ft_cpp", { clear = true }),
    callback = function()
        vim.opt_local.commentstring = "// %s"
    end,
})
