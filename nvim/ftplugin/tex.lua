local run_cmd_on_key = require("custom/functions").run_cmd_on_key

vim.opt_local.errorformat = "%f:%l: %m"

run_cmd_on_key({
    fn_cmd = function()
        return {
            "pdflatex",
            "-shell-escape",
            "-file-line-error",
            "-interaction=nonstopmode",
            "-halt-on-erro",
            vim.fn.expand("%:p"),
        }
    end,
    onsuccess = function()
        vim.cmd("silent !~/configs/scripts/showme.bash --silent-detached '%:p:r.pdf' &>/dev/null &")
    end,
    desc = "[B]uild LaTeX",
    keys = "<space>bb",
})
