require("custom/options")
require("custom/lazy")

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "gitcommit", "hgcommit" },
    group = vim.api.nvim_create_augroup("ft_vcs", { clear = true }),
    callback = function()
        -- Autowrap at 80 characters.
        vim.opt_local.textwidth = 80
        vim.opt_local.formatoptions:append("t")
    end,
})
