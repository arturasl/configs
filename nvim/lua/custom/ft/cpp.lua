vim.api.nvim_create_autocmd("FileType", {
    pattern = { "cpp" },
    group = vim.api.nvim_create_augroup("ft_cpp", { clear = true }),
    callback = function()
        vim.opt_local.makeprg = "g++"
            .. " -g "
            .. " -pedantic"
            .. " -std=c++20"
            .. " -Wall -Wextra"
            .. " -Wshadow"
            .. " -Wnon-virtual-dtor"
            .. " -Woverloaded-virtual"
            .. " -Wold-style-cast"
            .. " -Wcast-align"
            .. " -Wuseless-cast"
            .. " -Wfloat-equal"
            .. " -fsanitize=address"
            .. " $* '%' -o '%:r'"

        if vim.loop.fs_stat("./in") then
            vim.keymap.set("n", ",br", ":!time ./%:r < in<cr>", { desc = "Run" })
        else
            vim.keymap.set("n", ",br", ":!time ./%:r<cr>", { desc = "Run" })
        end
    end,
})
