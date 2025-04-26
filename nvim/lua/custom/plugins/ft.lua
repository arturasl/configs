return {
    "hat0uma/csvview.nvim",
    config = function()
        local csvview = require("csvview")
        csvview.setup({
            parser = {
                delimiter = function(bufnr)
                    local first_line = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] or ""

                    local char_hist = {}
                    for ch in first_line:gmatch(".") do
                        char_hist[ch] = (char_hist[ch] or 0) + 1
                    end

                    local sorted_hist = {}
                    for k, v in pairs(char_hist) do
                        table.insert(sorted_hist, { k, v })
                    end
                    table.sort(sorted_hist, function(lhs, rhs)
                        return lhs[1] < rhs[1]
                    end)

                    local delimiters = { [","] = true, [";"] = true, ["|"] = true }
                    for _, vk in pairs(sorted_hist) do
                        local ch = vk[1]
                        if delimiters[ch] then
                            return ch
                        end
                    end

                    return ","
                end,
            },
            view = {
                header_lnum = 1,
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
