return {
    "nvim-lualine/lualine.nvim",
    config = function()
        require("lualine").setup({
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { "filename" },
                lualine_x = { "" },
                lualine_y = { "" },
                lualine_z = { "" },
            },
            sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { "filename" },
                lualine_x = { "" },
                lualine_y = { "" },
                lualine_z = { "" },
            },
            tabline = {
                lualine_a = { "mode" },
                lualine_b = { "diagnostics" },
                lualine_c = {
                    {
                        "buffers",
                        show_modified_status = false,
                        mode = 4,
                        symbols = {
                            alternate_file = "",
                        },
                    },
                },
                lualine_x = { "encoding", "fileformat", "filetype" },
                lualine_y = { "progress" },
                lualine_z = { "location" },
            },
        })
    end,
}
