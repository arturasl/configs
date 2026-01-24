local run_cmd_on_key = require("custom.functions").run_cmd_on_key

run_cmd_on_key({
    fn_cmd = function()
        local fp_name = vim.fn.expand("%")
        local perm_str = vim.fn.getfperm(fp_name)
        if not string.match(perm_str, "x", 3) then
            local ans = vim.fn.input("File is not executable, make it executable? [y/n]: ")
            if ans ~= "y" and ans ~= "" then
                return { "echo", "File is not executable" }
            end

            vim.cmd("!chmod a+x " .. vim.fn.shellescape(fp_name))
        end

        return { "time", "./" .. fp_name }
    end,
    pipe_first_known_file = { "./in", "./small.in", "./large.in" },
    desc = "[R]un Shell",
    keys = "<space>br",
})
