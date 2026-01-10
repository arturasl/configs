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
else
    run_cmd_on_key({
        fn_cmd = function()
            return { "time", "clojure", "-M", vim.fn.expand("%") }
        end,
        pipe_first_known_file = { "./in", "./small.in", "./large.in" },
        desc = "[R]un Clojure",
        keys = "<space>br",
    })
end

local lein_repl_jobid = nil
local start_repl_if_needed = function()
    if lein_repl_jobid then
        local status = vim.fn.jobwait({ lein_repl_jobid }, 0)[1]
        if status == -1 then -- `jobwait` timed out == job still runs.
            return
        end
    end

    local lein_project_root = vim.fs.root(vim.fn.getcwd(), { "project.clj" })
    if not lein_project_root then
        return
    end

    lein_repl_jobid = vim.fn.jobstart({
        "lein",
        "update-in",
        ":plugins",
        "conj",
        "[cider/cider-nrepl RELEASE]",
        "--",
        "repl",
    }, { cwd = lein_project_root })
end
start_repl_if_needed()
