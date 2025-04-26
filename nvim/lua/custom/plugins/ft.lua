return {
    "hat0uma/csvview.nvim",
    config = function()
        local csvview = require("csvview")
        csvview.setup({
            parser = {
                delimiter = ";",
            },
            view = {
                header_lnum = 1,
                display_mode = "border",
            },
            keymaps = {
                jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
                jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
            },
        })

        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "csv" },
            group = vim.api.nvim_create_augroup("plug_ft_csv", { clear = true }),
            callback = function()
                csvview.enable()
                vim.opt_local.wrap = false
            end,
        })
    end,
}
