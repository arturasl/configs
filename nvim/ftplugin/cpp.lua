local run_cmd_on_key = require("custom/functions").run_cmd_on_key

vim.opt_local.commentstring = "// %s"
vim.opt.shiftwidth = 2 -- Numbers of spaces to <> commands.
vim.opt.softtabstop = 2 -- If someone uses spaces delete them with backspace.
vim.opt.tabstop = 2 -- Numbers of spaces of tab character.

local create_cpp_args = function()
    -- Intentionally in function to delay `expand`.
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
end

run_cmd_on_key({
    fn_cmd = create_cpp_args,
    desc = "[B]uild Cpp",
    keys = "<space>bb",
})

run_cmd_on_key({
    fn_cmd = function()
        return vim.list_extend(
            create_cpp_args(),
            { "&&", "echo", "Build finished, running.", "&&", "time", vim.fn.expand("%:p:r") }
        )
    end,
    pipe_first_known_file = { "./in", "./small.in", "./large.in" },
    desc = "[R]un Cpp",
    keys = "<space>br",
})
