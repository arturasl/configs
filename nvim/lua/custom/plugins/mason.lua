return {
    -- Installs LSP servers, formatters, linters, etc.
    "williamboman/mason.nvim",
    config = function()
        require("mason").setup()
    end,
}
