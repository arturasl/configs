local onsuccess = function(task, fn)
    task:subscribe("on_complete", function(_, status)
        if status ~= require("overseer").STATUS.SUCCESS then
            return
        end
        fn()
    end)
end

local default_components = {
    "on_exit_set_status",
    {
        "unique",
        replace = true, -- If task already exists, stop it and start again.
    },
    {
        "on_output_quickfix",
        open = true, -- Open on any output.
        close = false, -- Do not close if no entries matched errorformat.
        set_diagnostics = true, -- Load errors as diagnostics.
        tail = true, -- Move down as output is produced.
    },
}

return {
    "stevearc/overseer.nvim",
    config = function()
        local overseer = require("overseer")
        overseer.setup({})

        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "tex" },
            group = vim.api.nvim_create_augroup("ft_tex", { clear = true }),
            callback = function()
                vim.keymap.set("n", "<space>bb", function()
                    vim.opt_local.errorformat = "%f:%l: %m"

                    local task = overseer.new_task({
                        cmd = { "pdflatex" },
                        args = {
                            "-shell-escape",
                            "-file-line-error",
                            "-interaction=nonstopmode",
                            vim.fn.expand("%"),
                        },
                        components = default_components,
                    })

                    onsuccess(task, function()
                        vim.cmd("silent !~/configs/scripts/showme.bash --silent-detached %:r.pdf &>/dev/null &")
                    end)

                    task:start()
                end, { desc = "Build LaTeX", buffer = true })
            end,
        })

        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "dot" },
            group = vim.api.nvim_create_augroup("ft_dot", { clear = true }),
            callback = function()
                vim.keymap.set("n", "<space>bb", function()
                    local task = overseer.new_task({
                        cmd = { "dot" },
                        args = {
                            vim.fn.expand("%"),
                            "-Tpng",
                            "-O",
                        },
                        components = default_components,
                    })

                    onsuccess(task, function()
                        vim.cmd("silent !~/configs/scripts/showme.bash --silent-detached %.png &>/dev/null &")
                    end)

                    task:start()
                end, { desc = "Build Dot", buffer = true })
            end,
        })

        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "cpp" },
            group = vim.api.nvim_create_augroup("ft_cpp", { clear = true }),
            callback = function()
                vim.keymap.set("n", "<space>bb", function()
                    overseer
                        .new_task({
                            cmd = { "g++" },
                            args = {
                                "-g",
                                "-pedantic",
                                "-std=c++20",
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
                                vim.fn.expand("%"),
                                "-o",
                                vim.fn.expand("%:r"),
                            },
                            components = default_components,
                        })
                        :start()
                end, { desc = "Build Cpp", buffer = true })

                if vim.loop.fs_stat("./in") then
                    vim.keymap.set("n", "<space>br", "<cmd>!time ./%:r < in<cr>", { desc = "Run", buffer = true })
                else
                    vim.keymap.set("n", "<space>br", "<cmd>!time ./%:r<cr>", { desc = "Run", buffer = true })
                end
            end,
        })
    end,
}
