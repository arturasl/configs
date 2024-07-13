return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
        local wk = require("which-key")
        wk.setup()
        wk.add({
            { "<space>b", group = "[B]uild" },
            { "<space>s", group = "[S]earch" },
            { "<space>l", group = "[L]SP" },
        })
    end,
}
