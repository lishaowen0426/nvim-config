return {
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.4',
        dependencies = { { 'nvim-lua/plenary.nvim', }, { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build', }, },
        config = function()
            local telescope = require('telescope')
            telescope.setup {
                extensions = {
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "ignore_case",
                    },
                },
                pickers = {
                    find_files = {},
                },
            }
            telescope.load_extension('fzf')
            telescope.load_extension("yank_history")

            local builtin = require 'telescope.builtin'
            local yank_history = require("telescope").extensions.yank_history
            vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "find files", })
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "live grep", })
            vim.keymap.set('n', '<leader>fc', builtin.grep_string, { desc = "grep string", })
            vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, { desc = "list document symbols", })
            vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "list buffers", })
            vim.keymap.set('n', '<leader>fy', yank_history.yank_history, { desc = "list yanks", })
        end,

    },
}
