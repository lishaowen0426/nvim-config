return {
    {
        "nvim-treesitter/nvim-treesitter",
        version = false,
        build = ":TSUpdate",
        event = { "BufEnter", },
        init = function(plugin)
            -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
            -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
            -- no longer trigger the **nvim-treeitter** module to be loaded in time.
            -- Luckily, the only thins that those plugins need are the custom queries, which we make available
            -- during startup.
            require("lazy.core.loader").add_to_rtp(plugin)
            require("nvim-treesitter.query_predicates")
        end,
        cmd = { "TSUpdateSync", "TSUpdate", "TSInstall", },
        ---@type TSConfig
        ---@diagnostic disable-next-line: missing-fields
        opts = {
            highlight = { enable = true, },
            indent = { enable = true, },
            ensure_installed = {
                "bash",
                "c",
                "diff",
                "html",
                "javascript",
                "jsdoc",
                "json",
                "jsonc",
                "lua",
                "luadoc",
                "luap",
                "markdown",
                "markdown_inline",
                "python",
                "query",
                "regex",
                "toml",
                "tsx",
                "typescript",
                "vim",
                "vimdoc",
                "yaml",
                "go",
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<C-space>",
                    node_incremental = "<C-space>",
                    scope_incremental = false,
                    node_decremental = "<bs>",
                },
            },
        },
        ---@param opts TSConfig
        config = function(_, opts)
            if type(opts.ensure_installed) == "table" then
                ---@type table<string, boolean>
                local added = {}
                opts.ensure_installed = vim.tbl_filter(function(lang)
                    if added[lang] then
                        return false
                    end
                    added[lang] = true
                    return true
                end, opts.ensure_installed)
            end
            require("nvim-treesitter.configs").setup(opts)
        end,
    },

    -- treesitter-textobject
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = { "nvim-treesitter/nvim-treesitter", },
        opts = {
            textobjects = {
                move = {
                    enable = true,
                    set_jumps = false,
                    goto_next_start = {
                        ["]]"] = "@parameter.inner",
                    },
                },
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ["wq"] = "@parameter.inner",
                    },
                },
            },

        },
        config = function(_, opts)
            require 'nvim-treesitter.configs'.setup(opts)
        end,

    },

    -- Show context of the current function
    {
        "nvim-treesitter/nvim-treesitter-context",
        opts = { enabled = true, mode = "cursor", max_lines = 2, },
        config = function(_, opts)
            vim.keymap.set("n", "[c", function() require("treesitter-context").go_to_context() end,
                { silent = true, })
            vim.keymap.set('n', '[[', function()
                local ts = require("nvim-treesitter.ts_utils")
                local node = ts.get_node_at_cursor()
                ts.goto_node(ts.get_next_node(node, false, false), false, true)
            end, { desc = "go to next parameter", })
        end,

    },

    -- Automatically add closing tags for HTML and JSX
    {
        "windwp/nvim-ts-autotag",
        opts = {},
    },
}
