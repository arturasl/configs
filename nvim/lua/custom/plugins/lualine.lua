local functions = require("custom/functions")

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

local get_lsp_str = function()
    local lsps = {}
    for _, lsp in ipairs(vim.lsp.get_clients({ bufnr = 0 }) or {}) do
        table.insert(lsps, lsp.name)
    end
    return table.concat(lsps, ", ")
end

local get_formatters_str = function()
    if not functions.is_plugin_loaded("conform.nvim") then
        return ""
    end
    return table.concat(require("conform").list_formatters_for_buffer(0), ", ")
end

local get_linters_str = function()
    if not functions.is_plugin_loaded("nvim-lint") then
        return ""
    end

    for ft, available in pairs(require("lint").linters_by_ft) do
        if ft == vim.bo.ft then
            return table.concat(available, ", ")
        end
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
            options = {
                component_separators = { left = "", right = "|" },
                section_separators = { left = "", right = "" },
            },
            inactive_sections = per_window_sections,
            sections = per_window_sections,
            tabline = {
                lualine_a = { "mode", get_paste_mode_str, get_macro_mode_str },
                lualine_b = {
                    {
                        "diagnostics",
                        on_click = function()
                            vim.cmd.normal(" ld")
                        end,
                    },
                },
                lualine_c = {
                    {
                        "buffers",
                        symbols = {
                            modified = "",
                            alternate_file = "",
                        },
                        buffers_color = {
                            active = "lualine_b_normal",
                            inactive = "lualine_c_normal",
                        },
                    },
                },
                lualine_x = {
                    get_lsp_str,
                    {
                        "lsp_progress",
                        display_components = { "spinner" },
                        spinner_symbols = { "🌑 ", "🌒 ", "🌓 ", "🌔 ", "🌕 ", "🌖 ", "🌗 ", "🌘 " },
                    },
                    get_linters_str,
                    get_formatters_str,
                    {
                        require("lazy.status").updates,
                        cond = require("lazy.status").has_updates,
                        on_click = function()
                            vim.cmd.Lazy()
                        end,
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
