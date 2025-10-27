local run_cmd_on_key = require("custom/functions").run_cmd_on_key

if vim.fn.findfile("project.clj", ".;") ~= "" then
    run_cmd_on_key({
        fn_cmd = function()
            return { "time", "lein", "run", vim.fn.expand("%") }
        end,
        pipe_first_known_file = { "./in", "./small.in", "./large.in" },
        desc = "Build & [R]un Leiningen",
        keys = "<space>br",
    })

    run_cmd_on_key({
        fn_cmd = function()
            return { "lein", "test" }
        end,
        desc = "[T]est Leiningen",
        keys = "<space>bt",
    })
end
