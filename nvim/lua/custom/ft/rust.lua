vim.api.nvim_create_autocmd("FileType", {
    pattern = { "rust" },
    group = vim.api.nvim_create_augroup("ft_rust", { clear = true }),
    callback = function()
        local run_cmd = ":!time"
        if vim.fn.findfile("Cargo.toml", ".;") ~= "" then
            vim.opt_local.makeprg = "cargo build --release --quiet"
            run_cmd = run_cmd .. " cargo run --release"
        else
            vim.opt_local.makeprg = "rustc %"
            run_cmd = run_cmd .. " ./%:r"
        end

        if vim.loop.fs_stat("./in") then
            run_cmd = run_cmd .. " < in"
        end
        run_cmd = run_cmd .. "<cr>"

        vim.keymap.set("n", ",cr", run_cmd, { desc = "Run" })
    end,
})
