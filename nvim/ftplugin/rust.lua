local run_cmd_on_key = require("custom/functions").run_cmd_on_key

if vim.fn.findfile("Cargo.toml", ".;") ~= "" then
    run_cmd_on_key({
        fn_cmd = function()
            return { "cargo", "build", "--release", "--quiet" }
        end,
        desc = "[B]uild Cargo",
        keys = "<space>bb",
    })
else
    run_cmd_on_key({
        fn_cmd = function()
            return { "rustc", vim.fn.expand("%:p") }
        end,
        desc = "[B]uild Rust",
        keys = "<space>bb",
    })
end

run_cmd_on_key({
    fn_cmd = function()
        local run_cmd = { "time" }
        if vim.fn.findfile("Cargo.toml", ".;") ~= "" then
            vim.list_extend(run_cmd, { "cargo", "run", "--release" })
        else
            run_cmd[#run_cmd + 1] = vim.fn.expand("%:p:r")
        end
        return run_cmd
    end,
    pipe_first_known_file = { "./in", "./small.in", "./large.in" },
    desc = "[R]un Rust",
    keys = "<space>br",
})
