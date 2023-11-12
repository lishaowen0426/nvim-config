return {
    {
        "folke/which-key.nvim",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        priority = 100,
        config = function()
            require("which-key").setup {}
        end,

    },
}
