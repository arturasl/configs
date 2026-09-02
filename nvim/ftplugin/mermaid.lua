local run_cmd_on_key = require("custom.functions").run_cmd_on_key

run_cmd_on_key({
    fn_cmd = function()
        return { "mmdc", "--input", vim.fn.expand("%:p"), "--output", vim.fn.expand("%:p:r") .. ".svg" }
    end,
    onsuccess = function()
        vim.cmd("silent !~/configs/scripts/showme.bash --silent-detached '%:p:r.svg' &>/dev/null &")
    end,
    desc = "[B]uild Mermaid",
    keys = "<space>bb",
})
