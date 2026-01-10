local run_cmd_on_key = require("custom/functions").run_cmd_on_key

run_cmd_on_key({
    fn_cmd = function()
        return { "time", "lua", vim.fn.expand("%") }
    end,
    pipe_first_known_file = { "./in", "./small.in", "./large.in" },
    desc = "[R]un Lua",
    keys = "<space>br",
})
