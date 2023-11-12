vim.keymap.set('n', '<C-]>', 'g<C-]>', { desc = "go to tag", })


local function toggle_diagnostic()
    if vim.diagnostic.is_disabled() then
        vim.diagnostic.enable()
    else
        vim.diagnostic.disable()
    end
end

vim.keymap.set('n', '<leader>dd', toggle_diagnostic, { desc = "toggle diagnostic", })
vim.keymap.set('n', '<leader>nn', '<cmd>noh<cr>', { desc = "close highlight", })

vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true, })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true, })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true, })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true, })

-- save file
vim.keymap.set({ "i", "x", "n", "s", }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file", })

-- better up/down
vim.keymap.set({ "n", "x", }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, })
vim.keymap.set({ "n", "x", }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, })
vim.keymap.set({ "n", "x", }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, })
vim.keymap.set({ "n", "x", }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, })


-- Resize window using <ctrl> arrow keys
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height", })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height", })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width", })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width", })

-- new file
vim.keymap.set("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File", })


-- 'n' always for next, 'N' always for previous
vim.keymap.set("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next search result", })
vim.keymap.set("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result", })
vim.keymap.set("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result", })
vim.keymap.set("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev search result", })
vim.keymap.set("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result", })
vim.keymap.set("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result", })

--keywordprg
vim.keymap.set("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg", })
