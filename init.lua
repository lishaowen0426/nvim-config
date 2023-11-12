local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    -- bootstrap lazy.nvim
    -- stylua: ignore
    vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable",
        lazypath, })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({
    spec = {
        {
            'marko-cerovac/material.nvim',
            init = function()
                vim.g.material_style = 'darker'
                vim.cmd 'colorscheme material'
            end,
            priority = 100,
        },
        {
            dir = vim.fn.stdpath("config") .. "/lua/my-plugins",
            priority = 90,
            lazy = false,
            config = function(_)
                require('config')
            end,
        },
        { import = "plugins", },
    },
    defaults = {
        lazy = false,
        version = false,           -- always use the latest git commit
    },
    checker = { enabled = true, }, -- automatically check for plugin updates
    performance = {
        rtp = {
            -- disable some rtp plugins
            disabled_plugins = {
                "gzip",
                -- "matchit",
                -- "matchparen",
                -- "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
})
