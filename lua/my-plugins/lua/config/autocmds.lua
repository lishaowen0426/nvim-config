-- kill float terminal before quit
-- see keymaps to map this command to <leader>zz
vim.api.nvim_create_user_command("Z", function(opts)
    vim.cmd("FloatermKill!")
    vim.cmd("wa|qa")
end, {
    desc = "kill float term, save all and quit",
})



local ftgroup = vim.api.nvim_create_augroup("floatterminal", { clear = true, })
vim.api.nvim_create_autocmd({ "VimLeave", "VimLeavePre", }, {
    pattern = "*",
    group = ftgroup,
    command = "FloatrmKill!",
})
