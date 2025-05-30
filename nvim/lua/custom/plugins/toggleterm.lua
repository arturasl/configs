local remove_trailing_lines = function(lines, trailing_if_regex)
    while #lines ~= 0 do
        if lines[#lines]:gsub(trailing_if_regex, "") ~= "" then
            break
        end
        lines[#lines] = nil
    end
end

local get_buf_lines = function(bufnr)
    local num_lines = vim.api.nvim_buf_line_count(bufnr)
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, num_lines, true)
    return lines
end

local get_window_height = function(type)
    for _, win in pairs(vim.fn.getwininfo()) do
        if win[type] == 1 then
            return win.height
        end
    end
    return 0
end

local TERM = nil
local create_build_cmd = function(options)
    options = vim.tbl_extend("keep", options, { open_qf = false, keys = "<space>bb" })

    vim.keymap.set("n", options.keys, function()
        local preserve = require("custom/functions").preserve_cursor
        local Terminal = require("toggleterm.terminal").Terminal
        local cmd = ""
        -- Note that cmd is delayed so that vim.fn.expand() would happen after
        -- keymap.
        for _, val in ipairs(options.fn_cmd()) do
            cmd = cmd .. val .. " "
        end

        preserve(function()
            -- Preserve quickfix and/or terminal window height if it is opened.
            local orig_height = math.max(get_window_height("quickfix"), get_window_height("terminal"))
            -- Close quickfix.
            vim.cmd.cclose()
            -- Close terminal.
            if TERM ~= nil then
                TERM:close()
            end

            TERM = Terminal:new({
                cmd = cmd,
                hidden = true, -- Do not show as part of toggleterm managed terminals.
                start_in_insert = false,
                close_on_exit = false,
                auto_scroll = true,
                on_exit = function(term, _, exit_code)
                    if options.open_qf then
                        local term_lines = get_buf_lines(term.bufnr)
                        remove_trailing_lines(term_lines, " ")
                        term_lines[#term_lines + 1] = ""
                        term_lines[#term_lines + 1] = string.format("[Exit code: %d]", exit_code)
                        vim.fn.setqflist({}, "r", { lines = term_lines })

                        preserve(function()
                            local term_height = get_window_height("terminal")
                            term:close()

                            -- Open quickfix window taking full vertical space.
                            vim.cmd("botright copen " .. term_height)
                            -- Scroll to bottom of quickfix.
                            vim.cmd.cbottom()
                        end)
                    end

                    if exit_code == 0 and options.onsuccess ~= nil then
                        options.onsuccess()
                    end
                end,
            })
            TERM:open(orig_height)
        end)
    end, { desc = options.desc, buffer = true })
end

return {
    "akinsho/toggleterm.nvim",
    config = function()
        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "tex" },
            group = vim.api.nvim_create_augroup("ft_toogleterm_tex", { clear = true }),
            callback = function()
                vim.opt_local.errorformat = "%f:%l: %m"

                create_build_cmd({
                    fn_cmd = function()
                        return {
                            "pdflatex",
                            "-shell-escape",
                            "-file-line-error",
                            "-interaction=nonstopmode",
                            vim.fn.expand("%:p"),
                        }
                    end,
                    onsuccess = function()
                        vim.cmd("silent !~/configs/scripts/showme.bash --silent-detached '%:p:r.pdf' &>/dev/null &")
                    end,
                    desc = "Build LaTeX",
                })
            end,
        })

        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "dot" },
            group = vim.api.nvim_create_augroup("ft_toogleterm_dot", { clear = true }),
            callback = function()
                create_build_cmd({
                    fn_cmd = function()
                        return { "dot", vim.fn.expand("%:p"), "-Tpng", "-O" }
                    end,
                    onsuccess = function()
                        vim.cmd("silent !~/configs/scripts/showme.bash --silent-detached '%:p.png' &>/dev/null &")
                    end,
                    desc = "Build Dot",
                })
            end,
        })

        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "cpp" },
            group = vim.api.nvim_create_augroup("ft_toogleterm_cpp", { clear = true }),
            callback = function()
                create_build_cmd({
                    fn_cmd = function()
                        return {
                            "g++",
                            "-g",
                            "-pedantic",
                            "-std=c++23",
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
                            vim.fn.expand("%:p"),
                            "-o",
                            vim.fn.expand("%:p:r"),
                        }
                    end,
                    desc = "Build Cpp",
                })

                if vim.uv.fs_stat("./in") then
                    vim.keymap.set("n", "<space>br", "<cmd>!time '%:p:r' < in<cr>", { desc = "Run", buffer = true })
                else
                    vim.keymap.set("n", "<space>br", "<cmd>!time '%:p:r'<cr>", { desc = "Run", buffer = true })
                end
            end,
        })

        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "rust" },
            group = vim.api.nvim_create_augroup("ft_toogleterm_rust", { clear = true }),
            callback = function()
                if vim.fn.findfile("Cargo.toml", ".;") ~= "" then
                    create_build_cmd({
                        fn_cmd = function()
                            return { "cargo", "build", "--release", "--quiet" }
                        end,
                        desc = "Build Cargo",
                    })
                else
                    create_build_cmd({
                        fn_cmd = function()
                            return { "rust", vim.fn.expand("%:p") }
                        end,
                        desc = "Build Rust",
                    })
                end

                local run_cmd = "<cmd>!time"
                if vim.fn.findfile("Cargo.toml", ".;") ~= "" then
                    run_cmd = run_cmd .. " cargo run --release"
                else
                    run_cmd = run_cmd .. " '%:p:r'"
                end
                if vim.uv.fs_stat("./in") then
                    run_cmd = run_cmd .. " < in"
                end
                run_cmd = run_cmd .. "<cr>"

                vim.keymap.set("n", "<space>br", run_cmd, { desc = "Run", buffer = true })
            end,
        })

        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "python" },
            group = vim.api.nvim_create_augroup("ft_toogleterm_python", { clear = true }),
            callback = function()
                if vim.fn.findfile("pyproject.toml", ".;") ~= "" then
                    create_build_cmd({
                        fn_cmd = function()
                            local run_cmd = { "time", "uv", "run", vim.fn.expand("%") }
                            for _, known_file in ipairs({ "./in", "./small.in", "./large.in" }) do
                                if vim.uv.fs_stat(known_file) then
                                    run_cmd[#run_cmd + 1] = "<"
                                    run_cmd[#run_cmd + 1] = known_file
                                    break
                                end
                            end
                            return run_cmd
                        end,
                        desc = "Build & [R]un UV",
                        keys = "<space>br",
                        open_qf = false,
                    })
                    create_build_cmd({
                        fn_cmd = function()
                            return { "uv", "run", "pytest", vim.fn.expand("%") }
                        end,
                        desc = "[T]est UV",
                        keys = "<space>bt",
                        open_qf = false,
                    })
                else
                    local run_cmd = "<cmd>!time python3 '%:p'"
                    if vim.uv.fs_stat("./in") then
                        run_cmd = run_cmd .. " < in"
                    end
                    run_cmd = run_cmd .. "<cr>"

                    vim.keymap.set("n", "<space>br", run_cmd, { desc = "Run", buffer = true })
                end
            end,
        })
    end,
}
