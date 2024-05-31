local get_paste_mode_str = function()
    if vim.o.paste then
        return "PASTE"
    end
    return ""
end

local get_macro_mode_str = function()
    local recording_to_register = vim.fn.reg_recording()
    if recording_to_register == "" then
        return ""
    end
    return string.format("RECORDING: @%s", recording_to_register)
end

local get_search_count_str = function()
    local ok, result = pcall(vim.fn.searchcount, { maxcount = 999, timeout = 500 })
    if not ok or next(result) == nil then
        return ""
    end

    local total = math.min(result.total, result.maxcount)
    if total == 0 then
        return ""
    end

    return string.format(" %d/%d", result.current, total)
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
                lualine_a = { "mode", get_paste_mode_str, get_macro_mode_str },
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
                    {
                        require("lazy.status").updates,
                        cond = require("lazy.status").has_updates,
                    },
                    "encoding",
                    "fileformat",
                    "filetype",
                },
                lualine_y = { "progress", "location" },
                lualine_z = { get_search_count_str, "selectioncount" },
            },
        })
    end,
}
