return {
    "nvim-lualine/lualine.nvim",
    config = function()
        local per_window_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { "filename" },
            lualine_x = { "" },
            lualine_y = { "" },
            lualine_z = { "" },
        }

        require("lualine").setup({
            inactive_sections = per_window_sections,
            sections = per_window_sections,
            tabline = {
                lualine_a = { "mode" },
                lualine_b = { "diagnostics" },
                lualine_c = {
                    {
                        "buffers",
                        show_modified_status = false,
                        symbols = {
                            alternate_file = "",
                        },
                    },
                },
                lualine_x = { "encoding", "fileformat", "filetype" },
                lualine_y = { "progress", "location", "selectioncount" },
                lualine_z = {},
            },
        })
    end,
}
