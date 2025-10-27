local run_cmd_on_key = require("custom/functions").run_cmd_on_key

if vim.fn.findfile("pyproject.toml", ".;") ~= "" then
    run_cmd_on_key({
        fn_cmd = function()
            return { "time", "uv", "run", vim.fn.expand("%") }
        end,
        pipe_first_known_file = { "./in", "./small.in", "./large.in" },
        desc = "Build & [R]un UV",
        keys = "<space>br",
    })

    run_cmd_on_key({
        fn_cmd = function()
            return { "uv", "run", "pytest", vim.fn.expand("%") }
        end,
        desc = "[T]est UV",
        keys = "<space>bt",
    })
else
    run_cmd_on_key({
        fn_cmd = function()
            return { "time", "python3", vim.fn.expand("%") }
        end,
        pipe_first_known_file = { "./in", "./small.in", "./large.in" },
        desc = "[R]un Python",
        keys = "<space>br",
    })
end
