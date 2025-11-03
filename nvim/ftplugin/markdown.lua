local run_cmd_on_key = require("custom/functions").run_cmd_on_key

run_cmd_on_key({
    fn_cmd = function()
        return {
            "pandoc",
            vim.fn.expand("%:p"),
            "--variable=geometry:margin=1in",
            "--output",
            vim.fn.expand("%:p:r") .. ".pdf",
        }
    end,
    onsuccess = function()
        vim.cmd("silent !~/configs/scripts/showme.bash --silent-detached '%:p:r.pdf' &>/dev/null &")
    end,
    desc = "[B]uild Markdown to HTML",
    keys = "<space>bb",
})
