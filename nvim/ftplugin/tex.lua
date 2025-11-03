local run_cmd_on_key = require("custom/functions").run_cmd_on_key

vim.opt_local.errorformat = "%f:%l: %m"

run_cmd_on_key({
    fn_cmd = function()
        return {
            -- Similar to pdflatex, but runs multiple times to resolve any
            -- dependencies (e.g. ensures page number is never `??`).
            "latexmk",
            "-pdf",
            vim.fn.expand("%:p"),
        }
    end,
    onsuccess = function()
        -- Remove intermediate files.
        vim.cmd("silent !latexmk -c '%:p' &>/dev/null &")
        -- Open pdf in the default viewer.
        vim.cmd("silent !~/configs/scripts/showme.bash --silent-detached '%:p:r.pdf' &>/dev/null &")
    end,
    desc = "[B]uild LaTeX",
    keys = "<space>bb",
})
