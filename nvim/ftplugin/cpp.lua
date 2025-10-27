local run_cmd_on_key = require("custom/functions").run_cmd_on_key

vim.opt_local.commentstring = "// %s"

run_cmd_on_key({
    fn_cmd = function()
        return {
            "g++",
            "-g",
            "-pedantic",
            "-std=c++23",
            "-Wall",
            "-Wextra",
            "-Wshadow",
            "-Wnon-virtual-dtor",
            "-Woverloaded-virtual",
            "-Wold-style-cast",
            "-Wcast-align",
            "-Wuseless-cast",
            "-Wfloat-equal",
            "-fsanitize=address",
            vim.fn.expand("%:p"),
            "-o",
            vim.fn.expand("%:p:r"),
        }
    end,
    desc = "[B]uild Cpp",
    keys = "<space>bb",
})

run_cmd_on_key({
    fn_cmd = function()
        return { "time", vim.fn.expand("%:p:r") }
    end,
    pipe_first_known_file = { "./in", "./small.in", "./large.in" },
    desc = "[R]un Cpp",
    keys = "<space>br",
})
