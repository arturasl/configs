return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    branch = "main",
    config = function()
        local treesitter = require("nvim-treesitter")
        treesitter.setup({})

        local available_fts = {}
        for _, tier in ipairs({ 1, 2 }) do
            for _, available_ft in ipairs(treesitter.get_available(tier)) do
                available_fts[available_ft] = true
            end
        end

        vim.api.nvim_create_autocmd("FileType", {
            callback = function()
                local ft = vim.bo.filetype
                if not available_fts[ft] then
                    return
                end

                treesitter.install({ ft }):wait(300000)

                -- Syntax highlighting.
                vim.treesitter.start()
                -- Treesitter based indentation.
                vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end,
        })
    end,
}
