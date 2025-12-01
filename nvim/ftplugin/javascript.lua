local run_cmd_on_key = require("custom/functions").run_cmd_on_key

run_cmd_on_key({
    fn_cmd = function()
        local run_cmd = { "time" }
        if vim.fn.findfile("project.json", ".;") ~= "" then
            vim.list_extend(run_cmd, { "npm", "start" })
        else
            vim.list_extend(run_cmd, { "node", vim.fn.expand("%:p:r") })
        end
        return { "npm", "start" }
    end,
    pipe_first_known_file = { "./in", "./small.in", "./large.in" },
    desc = "[R]uild JS",
    keys = "<space>br",
})
