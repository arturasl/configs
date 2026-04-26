local run_cmd_on_key = require("custom.functions").run_cmd_on_key

local cabal_project = vim.fn.findfile("cabal.project", ".;")
if cabal_project ~= "" then
    assert(type(cabal_project) == "string")
    local pkg_name = vim.fn.fnamemodify(cabal_project, ":h:r")
    run_cmd_on_key({
        fn_cmd = function()
            return { "time", "cabal", "run", pkg_name }
        end,
        pipe_first_known_file = { "./in", "./small.in", "./large.in" },
        desc = "Build & [R]un Cabal",
        keys = "<space>br",
    })
end
