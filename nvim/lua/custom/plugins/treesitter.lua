return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    branch = "main",
    config = function()
        local treesitter = require("nvim-treesitter")
        treesitter.setup({})

        local available_langs = {}
        for _, tier in ipairs({ 1, 2 }) do
            for _, available_lang in ipairs(treesitter.get_available(tier)) do
                available_langs[available_lang] = true
            end
        end

        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("treesitter_init", { clear = true }),
            callback = function(event)
                local lang = vim.treesitter.language.get_lang(event.match) or event.match
                if not available_langs[lang] then
                    return
                end

                treesitter.install({ lang }):wait(300000)

                -- Syntax highlighting.
                vim.treesitter.start()
                -- Treesitter based indentation.
                vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end,
        })
    end,
}
