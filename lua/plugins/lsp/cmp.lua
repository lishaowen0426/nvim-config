local M = {}

function M.setup(_)
        local cmp = require'cmp'

vim.api.nvim_set_option_value('completeopt', 'menu,menuone,noselect', {})

    require('luasnip.loaders.from_vscode').lazy_load({
        path = "~/.local/share/nvim/site/pack/packer/start/friendly-snippets/snippets" })

    local select_opts = { behavior = cmp.SelectBehavior.Select }
    local luasnip = require('luasnip')

    cmp.setup({
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end,
        },

        completion = {
            keyword_length = 2,
        },
        mapping = cmp.mapping.preset.insert({
            ['<CR>'] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
            ['<Up>'] = cmp.mapping.select_prev_item(select_opts),
            ['<Down>'] = cmp.mapping.select_next_item(select_opts),
            ['<C-u>'] = cmp.mapping.scroll_docs(-4),
            ['<C-d>'] = cmp.mapping.scroll_docs(4),
            -- jump to the next placeholder in the snippet
            ['<C-j>'] = cmp.mapping(function(fallback)
                if luasnip.jumpable(1) then
                    luasnip.jump(1)
                else
                    fallback()
                end
            end, { 'i', 's' }),

            ['<Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item(select_opts)
                elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                else
                    fallback()
                end
            end, { 'i', 's' }),
        }),
        sources = {
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
            { name = 'buffer' },
            { name = 'tags' },
        },
    })
    cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = 'buffer' }
        }
    })

    cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            { name = 'path' },
            { name = 'cmdline' },
        })
    })



end

return M
