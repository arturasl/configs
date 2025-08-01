return {
    "hat0uma/csvview.nvim",
    ft = "csv",
    config = function()
        local csvview = require("csvview")
        csvview.setup({
            parser = {
                delimiter = {
                    ft = {},
                },
            },
            view = {
                display_mode = "border",
            },
            keymaps = {
                jump_next_field_start = { "<Tab>", mode = { "n", "v" } },
                jump_prev_field_start = { "<S-Tab>", mode = { "n", "v" } },
            },
        })

        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "csv" },
            group = vim.api.nvim_create_augroup("plug_ft_csv", { clear = true }),
            callback = function()
                csvview.enable()
                vim.opt_local.wrap = false
                vim.opt_local.colorcolumn = ""
            end,
        })
    end,
}
