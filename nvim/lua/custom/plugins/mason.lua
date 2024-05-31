return {
    -- Installs LSP servers, formatters, linters, etc.
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
        require("mason").setup()
    end,
}
