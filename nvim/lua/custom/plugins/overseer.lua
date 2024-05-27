local create_build_cmd = function(options)
    vim.keymap.set("n", "<space>bb", function()
        local overseer = require("overseer")

        local task = overseer.new_task({
            cmd = options.cmd,
            components = {
                "on_exit_set_status",
                {
                    "unique",
                    replace = true, -- If task already exists, stop it and start again.
                },
                {
                    "on_output_quickfix",
                    set_diagnostics = true, -- Load errors as diagnostics.
                    tail = true, -- Move down as output is produced.
                },
            },
        })

        task:subscribe("on_complete", function(_, status)
            if status ~= require("overseer").STATUS.SUCCESS then
                return
            end
            if options.onsuccess ~= nil then
                options.onsuccess()
            end

            -- Move cursor to the last non empty line in the quickfix
            -- without focusing it.
            local qf_winid = vim.fn.getqflist({ context = 0, winid = 0 }).winid
            local qf_bufnr = vim.api.nvim_win_get_buf(qf_winid)
            local last_line_nr = vim.api.nvim_buf_line_count(qf_bufnr)
            while last_line_nr ~= 0 do
                local lines = vim.api.nvim_buf_get_lines(qf_bufnr, last_line_nr - 1, last_line_nr, true)
                if lines[1] ~= "|| " then
                    break
                end
                last_line_nr = last_line_nr - 1
            end

            vim.api.nvim_win_set_cursor(qf_winid, { last_line_nr, 0 })
        end)

        -- Clear and open quickfix before starting stream new data to it.
        vim.fn.setqflist({})
        vim.cmd("copen")

        -- Start the job.
        task:start()
    end, { desc = options.desc, buffer = true })
end

return {
    "stevearc/overseer.nvim",
    config = function()
        local overseer = require("overseer")
        overseer.setup({})

        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "tex" },
            group = vim.api.nvim_create_augroup("ft_tex", { clear = true }),
            callback = function()
                vim.opt_local.errorformat = "%f:%l: %m"

                create_build_cmd({
                    cmd = {
                        "pdflatex",
                        "-shell-escape",
                        "-file-line-error",
                        "-interaction=nonstopmode",
                        vim.fn.expand("%"),
                    },
                    onsuccess = function()
                        vim.cmd("silent !~/configs/scripts/showme.bash --silent-detached %:r.pdf &>/dev/null &")
                    end,
                    desc = "Build LaTeX",
                })
            end,
        })

        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "dot" },
            group = vim.api.nvim_create_augroup("ft_dot", { clear = true }),
            callback = function()
                create_build_cmd({
                    cmd = { "dot", vim.fn.expand("%"), "-Tpng", "-O" },
                    onsuccess = function()
                        vim.cmd("silent !~/configs/scripts/showme.bash --silent-detached %.png &>/dev/null &")
                    end,
                    desc = "Build Dot",
                })
            end,
        })

        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "cpp" },
            group = vim.api.nvim_create_augroup("ft_cpp", { clear = true }),
            callback = function()
                create_build_cmd({
                    cmd = {
                        "g++",
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
                    desc = "Build Cpp",
                })

                if vim.loop.fs_stat("./in") then
                    vim.keymap.set("n", "<space>br", "<cmd>!time ./%:r < in<cr>", { desc = "Run", buffer = true })
                else
                    vim.keymap.set("n", "<space>br", "<cmd>!time ./%:r<cr>", { desc = "Run", buffer = true })
                end
            end,
        })

        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "rust" },
            group = vim.api.nvim_create_augroup("ft_rust", { clear = true }),
            callback = function()
                if vim.fn.findfile("Cargo.toml", ".;") ~= "" then
                    create_build_cmd({
                        cmd = { "cargo", "build", "--release", "--quiet" },
                        desc = "Build Cargo",
                    })
                else
                    create_build_cmd({
                        cmd = { "rust", vim.fn.expand("%") },
                        desc = "Build Rust",
                    })
                end

                local run_cmd = "<cmd>!time"
                if vim.fn.findfile("Cargo.toml", ".;") ~= "" then
                    run_cmd = run_cmd .. " cargo run --release"
                else
                    run_cmd = run_cmd .. " ./%:r"
                end
                if vim.loop.fs_stat("./in") then
                    run_cmd = run_cmd .. " < in"
                end
                run_cmd = run_cmd .. "<cr>"

                vim.keymap.set("n", "<space>cr", run_cmd, { desc = "Run", buffer = true })
            end,
        })
    end,
}
