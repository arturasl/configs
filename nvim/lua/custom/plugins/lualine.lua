local get_paste_mode_str = function()
    if vim.o.paste then
        return "PASTE"
    end
    return ""
end

return {
    "nvim-lualine/lualine.nvim",
    dependencies = {
        -- Provides 'lsp_progress'
        "arkav/lualine-lsp-progress",
    },
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
                lualine_a = { "mode", get_paste_mode_str },
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
                lualine_x = {
                    {
                        "lsp_progress",
                        display_components = { "lsp_client_name", "spinner" },
                        spinner_symbols = { "🌑 ", "🌒 ", "🌓 ", "🌔 ", "🌕 ", "🌖 ", "🌗 ", "🌘 " },
                    },
                    "encoding",
                    "fileformat",
                    "filetype",
                },
                lualine_y = { "progress", "location", "selectioncount" },
                lualine_z = {},
            },
        })
    end,
}
