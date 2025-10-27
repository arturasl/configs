local run_cmd_on_key = require("custom/functions").run_cmd_on_key

run_cmd_on_key({
    fn_cmd = function()
        return { "dot", vim.fn.expand("%:p"), "-Tpng", "-O" }
    end,
    onsuccess = function()
        vim.cmd("silent !~/configs/scripts/showme.bash --silent-detached '%:p.png' &>/dev/null &")
    end,
    desc = "[B]uild Dot",
    keys = "<space>bb",
})
