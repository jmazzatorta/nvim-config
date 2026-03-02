return {

    -- === THEME ===
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        opts = {
            flavour = "macchiato",
            transparent_background = true,
        },
        config = function(plugin, opts)
            require("catppuccin").setup(opts)
            vim.cmd.colorscheme("catppuccin")
        end,
    },

    -- === STATUS BAR ===
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = { options = { theme = "catppuccin" } },
    },

    -- === FILE EXPLORER ===
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = { { "<leader>n", ":NvimTreeToggle<CR>", silent = true, desc = "File tree" } },
        opts = {
            renderer = {
                icons = {
                    glyphs = {
                        folder = { arrow_closed = "▸", arrow_open = "▾" },
                    },
                },
            },
        },
    },

    -- === INDENTATION & AUTOPAIRS ===
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {}
    },
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = true
    },

    -- === CODE FOLDING ===
    {
        "kevinhwang91/nvim-ufo",
        dependencies = { "kevinhwang91/promise-async" },
        event = "BufRead",
        init = function()
            vim.o.foldcolumn = "0"
            vim.o.foldlevel = 99
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true
            vim.o.fillchars = "eob: ,fold: ,foldopen:▾,foldsep:│,foldclose:▸"
        end,
        opts = {
            provider_selector = function(bufnr, filetype, buftype)
                return { "treesitter", "indent" }
            end,
        },
    },

    -- === WHICH-KEY ===
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            icons = { group = "󰉋 " },
        },
        config = function(_, opts)
            local wk = require("which-key")
            wk.setup(opts)

            wk.add({
                { "<leader>f", group = "Find" },

                { "<leader>l",  group = "LSP" },
                { "<leader>ld", desc = "Definition" },
                { "<leader>lk", desc = "Hover docs" },
                { "<leader>li", desc = "Implementation" },
                { "<leader>lr", desc = "References" },
                { "<leader>la", desc = "Code action" },
                { "<leader>le", desc = "Line diagnostic" },
                { "<leader>lc", desc = "Run CodeLens" },
                { "<leader>lt", desc = "Toggle CodeLens" },

                { "<leader>t",  group = "LaTeX" },
                { "<leader>tc", desc = "Compile" },
                { "<leader>tv", desc = "View PDF" },
                { "<leader>ts", desc = "Stop compiler" },
                { "<leader>te", desc = "Errors" },
                { "<leader>tt", desc = "Table of contents" },
                { "<leader>tk", desc = "Clean aux" },
            })
        end,
    },

    -- === TELESCOPE ===
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
        },
        keys = {
            { "<leader>ff", function() require("telescope.builtin").find_files() end,           desc = "Files" },
            { "<leader>fg", function() require("telescope.builtin").live_grep() end,            desc = "Grep" },
            { "<leader>fb", function() require("telescope.builtin").buffers() end,              desc = "Buffers" },
            { "<leader>fh", function() require("telescope.builtin").help_tags() end,            desc = "Help" },
            { "<leader>fs", function() require("telescope.builtin").lsp_document_symbols() end, desc = "Symbols" },
            { "<leader>fd", function() require("telescope.builtin").diagnostics() end,          desc = "Diagnostics" },
            { "<leader>fr", function() require("telescope.builtin").oldfiles() end,             desc = "Recent" },
        },
        opts = {
            defaults = {
                prompt_prefix = "   ",
                selection_caret = "  ",
                sorting_strategy = "ascending",
                layout_config = {
                    horizontal = { prompt_position = "top" },
                },
            },
        },
    },

    -- === LATEX (vimtex + zathura) ===
    {
        "lervag/vimtex",
        init = function()
            vim.g.vimtex_view_method = "zathura"
            vim.g.vimtex_compiler_method = "latexmk"
            vim.g.vimtex_compiler_latexmk = {
                options = {
                    "-pdf",
                    "-interaction=nonstopmode",
                    "-synctex=1",
                    "-pvc",
                },
            }
            vim.g.vimtex_quickfix_mode = 0
        end,
        ft = { "tex" },
        config = function()
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "tex",
                callback = function(args)
                    local map = function(keys, cmd, desc)
                        vim.keymap.set('n', keys, cmd, { buffer = args.buf, silent = true, desc = 'TeX: ' .. desc })
                    end
                    map('<leader>tc', '<cmd>VimtexCompile<CR>',       'Compile (continuous)')
                    map('<leader>tv', '<cmd>VimtexView<CR>',          'View PDF')
                    map('<leader>ts', '<cmd>VimtexStop<CR>',          'Stop compiler')
                    map('<leader>te', '<cmd>VimtexErrors<CR>',        'Errors')
                    map('<leader>tt', '<cmd>VimtexTocToggle<CR>',     'Table of contents')
                    map('<leader>tk', '<cmd>VimtexClean<CR>',         'Clean aux files')
                end,
            })
        end,
    },

    -- === MARKDOWN RENDERING (minimal, text only) ===
    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
        ft = { "markdown" },
        opts = {
            file_types = { "markdown" },
            code = {
                sign = false,
                width = 'block',
                right_pad = 1,
            },
            heading = {
                sign = false,
                icons = { '󰲡 ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' },
            },
        },
    },

    -- === LSP ===

    { "williamboman/mason.nvim", config = true },

    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            require("lspconfig")
            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            vim.o.updatetime = 300

            local codelens_enabled = false

            local function codelens_refresh(bufnr)
                if codelens_enabled then
                    vim.lsp.codelens.refresh({ bufnr = bufnr })
                end
            end

            local function codelens_clear(bufnr)
                vim.lsp.codelens.clear(nil, bufnr)
            end

            local on_attach = function(client, bufnr)
                local map = function(keys, func, desc)
                    vim.keymap.set('n', keys, func, { buffer = bufnr, noremap = true, silent = true, desc = 'LSP: ' .. desc })
                end

                -- Quick aliases
                map('gd', vim.lsp.buf.definition, 'Definition')
                map('K', vim.lsp.buf.hover, 'Hover')
                map('gi', vim.lsp.buf.implementation, 'Implementation')
                map('gr', vim.lsp.buf.references, 'References')

                -- <leader>l group
                map('<leader>ld', vim.lsp.buf.definition, 'Definition')
                map('<leader>lk', vim.lsp.buf.hover, 'Hover docs')
                map('<leader>li', vim.lsp.buf.implementation, 'Implementation')
                map('<leader>lr', vim.lsp.buf.references, 'References')
                map('<leader>la', vim.lsp.buf.code_action, 'Code action')
                map('<leader>le', vim.diagnostic.open_float, 'Line diagnostic')
                map('<leader>lc', vim.lsp.codelens.run, 'Run CodeLens')

                map('<leader>lt', function()
                    codelens_enabled = not codelens_enabled
                    if codelens_enabled then
                        codelens_refresh(bufnr)
                        vim.notify("CodeLens ON", vim.log.levels.INFO)
                    else
                        codelens_clear(bufnr)
                        vim.notify("CodeLens OFF", vim.log.levels.INFO)
                    end
                end, 'Toggle CodeLens')

                if client.server_capabilities.codeLensProvider then
                    vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
                        buffer = bufnr,
                        callback = function()
                            codelens_refresh(bufnr)
                        end,
                    })
                end

                if client.server_capabilities.inlayHintProvider then
                    vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
                end
            end

            local function setup_server(server_name, config)
                config = vim.tbl_deep_extend("force", {
                    on_attach = on_attach,
                    capabilities = capabilities,
                }, config or {})

                if vim.fn.has("nvim-0.11") == 1 then
                    if vim.lsp.config[server_name] then
                        vim.lsp.config[server_name] = vim.tbl_deep_extend("force", vim.lsp.config[server_name], config)
                    else
                        vim.lsp.config[server_name] = config
                    end
                    vim.lsp.enable(server_name)
                else
                    require('lspconfig')[server_name].setup(config)
                end
            end

            require('mason-lspconfig').setup({
                ensure_installed = {
                    "yamlls", "cssls", "dockerls", "clangd",
                    "pyright", "bashls",
                    "hls", "lua_ls", "texlab",
                },
                automatic_installation = false,
                handlers = {
                    function(server_name)
                        setup_server(server_name, {})
                    end,
                },
            })

            -- Custom server configs
            setup_server("vue_ls", {
                init_options = {
                    vue = { hybridMode = true },
                },
            })

            local mason_packages = vim.fn.stdpath("data") .. "/mason/packages"
            local volar_path = mason_packages .. "/vue-language-server"
            local vue_plugin_path = nil

            if vim.fn.isdirectory(volar_path) == 1 then
                local possible_paths = {
                    volar_path .. "/node_modules/@vue/language-server/node_modules/@vue/typescript-plugin",
                    volar_path .. "/node_modules/@vue/typescript-plugin"
                }
                for _, path in ipairs(possible_paths) do
                    if vim.fn.isdirectory(path) == 1 then
                        vue_plugin_path = path
                        break
                    end
                end
            end

            local plugins = {}
            if vue_plugin_path then
                table.insert(plugins, {
                    name = "@vue/typescript-plugin",
                    location = vue_plugin_path,
                    languages = { "vue" },
                })
            end

            setup_server("ts_ls", {
                init_options = {
                    plugins = plugins,
                    preferences = {
                        includeInlayParameterNameHints = 'none',
                        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                        includeInlayFunctionParameterTypeHints = false,
                        includeInlayVariableTypeHints = false,
                        includeInlayPropertyDeclarationTypeHints = false,
                        includeInlayFunctionLikeReturnTypeHints = false,
                        includeInlayEnumMemberValueHints = false,
                    },
                },
                filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
                on_attach = function(client, bufnr)
                    on_attach(client, bufnr)
                    local filetype = vim.bo[bufnr].filetype
                    if filetype == "javascript" or filetype == "vue" then
                        vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
                    end
                end,
            })

            setup_server("clangd", {
                cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=iwyu",
                    "--completion-style=detailed", "--function-arg-placeholders", "--fallback-style=llvm" },
                init_options = { usePlaceholders = true, completeUnimported = true, clangdFileStatus = true },
            })

            setup_server("hls", {
                filetypes = { 'haskell', 'lhaskell', 'cabal' },
                settings = {
                    haskell = {
                        plugin = {
                            eval = { globalOn = true },
                        }
                    }
                }
            })

            setup_server("lua_ls", {
                settings = {
                    Lua = {
                        runtime = { version = "LuaJIT" },
                        workspace = {
                            checkThirdParty = false,
                            library = { vim.env.VIMRUNTIME },
                        },
                        diagnostics = {
                            globals = { "vim" },
                        },
                    },
                },
            })

            -- texlab: LSP only (completion, diagnostics, symbols)
            -- build handled by vimtex, not texlab
            setup_server("texlab", {
                settings = {
                    texlab = {
                        build = { onSave = false },
                        forwardSearch = {
                            executable = "zathura",
                            args = { "--synctex-forward", "%l:1:%f", "%p" },
                        },
                    },
                },
            })
        end,
    },

    -- === COMPLETION ===
    {
        "hrsh7th/nvim-cmp",
        dependencies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path", "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip", "onsails/lspkind.nvim", "hrsh7th/cmp-nvim-lsp-signature-help" },
        config = function()
            local cmp = require('cmp')
            local luasnip = require('luasnip')
            local lspkind = require('lspkind')

            -- Load custom snippets
            luasnip.add_snippets("tex", require("snippets.tex"))
            cmp.setup({
                formatting = {
                    format = lspkind.cmp_format({
                        mode = 'symbol_text',
                        maxwidth = 50,
                        ellipsis_char = '...',
                    }),
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'nvim_lsp_signature_help' },
                    { name = 'luasnip' },
                    { name = 'buffer' },
                    { name = 'path' }
                },
                mapping = cmp.mapping.preset.insert({
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
                        elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
                        else fallback() end
                    end, { 'i', 's' }),
                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
                        elseif luasnip.jumpable(-1) then luasnip.jump(-1)
                        else fallback() end
                    end, { 'i', 's' }),
                    ['<C-d>'] = cmp.mapping.scroll_docs(4),
                    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                }),
            })
        end,
    },

    -- === TREESITTER ===
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
            require("nvim-treesitter.install").prefer_git = true

            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "markdown" },
                callback = function()
                    vim.treesitter.start()
                end,
            })
        end,
        opts = {
            ensure_installed = {
                "vue", "javascript", "typescript", "go", "python", "css", "html",
                "yaml", "lua", "vim", "markdown", "markdown_inline", "latex",
                "haskell", "bash",
            },
            sync_install = false,
            auto_install = true,
            highlight = { enable = true },
            indent = { enable = true },
        },
    },
}
