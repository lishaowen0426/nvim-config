return {

    {
        "neovim/nvim-lspconfig",
        dependencies = {
            { "williamboman/mason.nvim", },
            { "hrsh7th/cmp-nvim-lsp", },
            { "hrsh7th/cmp-buffer", },
            { "hrsh7th/cmp-path", },
            { "hrsh7th/cmp-cmdline", },
            { "hrsh7th/cmp-nvim-lua", },
            { "hrsh7th/nvim-cmp", },
            {
                "L3MON4D3/LuaSnip",
                version = "v2.*",
                build = "make install_jsregexp",
            },
            { "folke/neodev.nvim",     opts = {}, },
            { "chrisgrieser/cmp_yanky", },

        },

        config = function(_, opts)
            local lspconfig = require('lspconfig')
            require("plugins.lsp.cmp").setup(lspconfig)

            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            local on_attach = function(_, bufnr)
                local function buf_set_option(...)
                    vim.api.nvim_buf_set_option(bufnr, ...)
                end
            end

            lspconfig.lua_ls.setup {
                settings = {
                    completion = {
                        callSnippet = "Replace",
                    },
                },
                capabilities = capabilities,
                on_attach = on_attach,

            }

            lspconfig.clangd.setup {
                capabilities = capabilities,
                on_attach = function(_, bufnr)
                    local function buf_set_option(...)
                        vim.api.nvim_buf_set_option(bufnr, ...)
                    end
                end,
                cmd = { "clangd-17",
                    --                    "--background-index",
                    "--clang-tidy",
                    "--header-insertion=iwyu",
                    "--completion-style=detailed",
                    "--function-arg-placeholders",
                    "--fallback-style=llvm",
                },
                root_dir = function(fname)
                    return require("lspconfig.util").root_pattern(
                            "Makefile",
                            "configure.ac",
                            "configure.in",
                            "config.h.in",
                            "meson.build",
                            "meson_options.txt",
                            "build.ninja"
                        )(fname) or
                        require("lspconfig.util").root_pattern("compile_commands.json", "compile_flags.txt")(fname) or
                        require("lspconfig.util").find_git_ancestor(fname)
                end,
                init_options = {
                    usePlaceholders = true,
                    completeUnimported = true,
                    clangdFileStatus = true,
                },
            }



            capabilities.textDocument.completion.completionItem.snippetSupport = true

            require 'lspconfig'.jsonls.setup {
                capabilities = capabilities,
                root_dit = function()
                    return vim.fn.getcwd()
                end,
            }

            require('lspconfig').rust_analyzer.setup {
                capabilities = capabilities,
                ['rust-analyzer'] = {
                    inlayHints = {
                        closureCaptureHints = { enable = true, },
                    },

                },

                on_attach = function(client, bufnr)
                    local opts = { buffer = bufnr, noremap = true, silent = true, desc = "rust inlayHints", }

                    local toggle_inlay_hints = function()
                        if vim.lsp.inlay_hint.is_enabled() then
                            vim.lsp.inlay_hint.enable(0, false)
                        else
                            vim.lsp.inlay_hint.enable(0, true)
                        end
                    end

                    vim.keymap.set('n', '<leader>ci', toggle_inlay_hints, opts)
                end,

            }


            vim.api.nvim_create_autocmd("BufWritePre", {
                group = vim.api.nvim_create_augroup('UserLspConfig', { clear = false, }),
                buffer = buffer,
                callback = function(ev)
                    if (ev.file ~= "justfile") then
                        vim.lsp.buf.format { async = false, }
                    end
                end,

            })

            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('UserLspConfig', { clear = false, }),
                callback = function(ev)
                    if (ev.file == "justfile") then
                        return
                    end

                    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

                    -- if tagfile exists, use it(instead of the language server)
                    if table.getn(vim.fn.tagfiles()) > 0 then
                        vim.api.nvim_set_option_value('tagfunc', '', {})
                    end

                    local opts = { buffer = ev.buf, noremap = true, silent = true, }

                    vim.keymap.set('n', 'gd', vim.lsp.buf.definition,
                        vim.tbl_deep_extend("error", opts, { desc = "go to definition", }))
                    vim.keymap.set('n', '<leader>cc', vim.lsp.buf.incoming_calls, opts)
                    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
                    vim.keymap.set('n', '<leader>ca', function()
                        vim.lsp.buf.code_action({ apply = true, })
                    end, opts)
                    vim.keymap.set('n', '<leader>cr', '<cmd>ClangdSwitchSourceHeader<cr>',
                        { desc = "Switch source/header", })
                end,

            })
        end,
    },

    {

        "williamboman/mason.nvim",
        cmd = "Mason",
        build = ":MasonUpdate",
        opts = {
            ensure_installed = {
                --            "stylua",
                "shfmt",
                "lua-language-server",
            },
        },
        ---@param opts MasonSettings | {ensure_installed: string[]}
        config = function(_, opts)
            require("mason").setup(opts)
            local mr = require("mason-registry")
            mr:on("package:install:success", function()
                vim.defer_fn(function()
                    -- trigger FileType event to possibly load this newly installed LSP server
                    require("lazy.core.handler.event").trigger({
                        event = "FileType",
                        buf = vim.api.nvim_get_current_buf(),
                    })
                end, 100)
            end)
            local function ensure_installed()
                for _, tool in ipairs(opts.ensure_installed) do
                    local p = mr.get_package(tool)
                    if not p:is_installed() then
                        p:install()
                    end
                end
            end
            if mr.refresh then
                mr.refresh(ensure_installed)
            else
                ensure_installed()
            end
        end,
    },
    {
        "ray-x/go.nvim",
        dependencies = { -- optional packages
            "ray-x/guihua.lua",
            "neovim/nvim-lspconfig",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            require('go').setup {
                lsp_cfg = {
                    capabilities = capabilities,
                },
                -- other setups...
                luasnip = true,
                tag_options = "",
                lsp_inlay_hints = {
                    enable = false,
                },
            }
        end,
        ft = { "go", 'gomod', },

    },
}
