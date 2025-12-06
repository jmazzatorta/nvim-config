return {

    -- THEME (Catppuccin)
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

    -- STATUS BAR (Lualine)
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = { options = { theme = "catppuccin" } },
    },

    -- FILE EXPLORER (Nvim-Tree)
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = { { "<leader>n", ":NvimTreeToggle<CR>", silent = true, desc = "Toggle NvimTree" } },
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

    -- INDENTATION & AUTOPAIRS
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

    -- LATEX (VimTeX)
    {
        "lervag/vimtex",
        lazy = false, 
        init = function()
            -- Usa Zathura come visualizzatore 
            vim.g.vimtex_view_method = "zathura"
            -- Compilazione continua con latexmk
            vim.g.vimtex_compiler_method = "latexmk"
        end,
    },

    -- CODE FOLDING
    {
        "kevinhwang91/nvim-ufo",
        dependencies = { "kevinhwang91/promise-async" },
        event = "BufRead",

        init = function()
            vim.o.foldcolumn = "0"
            vim.o.foldlevel = 99
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true
            vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
        end,

        opts = {
            provider_selector = function(bufnr, filetype, buftype)
                return { "treesitter", "indent" }
            end,

            fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
                local newVirtText = {}
                local suffix = (' 󰁂 %d '):format(endLnum - lnum)
                local sufWidth = vim.fn.strdisplaywidth(suffix)
                local targetWidth = width - sufWidth
                local curWidth = 0
                for _, chunk in ipairs(virtText) do
                    local chunkText = chunk[1]
                    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
                    if targetWidth > curWidth + chunkWidth then
                        table.insert(newVirtText, chunk)
                    else
                        chunkText = truncate(chunkText, targetWidth - curWidth)
                        local hlGroup = chunk[2]
                        table.insert(newVirtText, {chunkText, hlGroup})
                        chunkWidth = vim.fn.strdisplaywidth(chunkText)
                        if curWidth + chunkWidth < targetWidth then
                            suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
                        end
                        break
                    end
                    curWidth = curWidth + chunkWidth
                end

                table.insert(newVirtText, {suffix, 'MoreMsg'})
                return newVirtText
            end
        },
    },

    -- === LSP SECTION ===

    -- MASON BASE
    {
        "williamboman/mason.nvim",
        config = true
    },

    -- MASON-LSPCONFIG & LSPCONFIG
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "neovim/nvim-lspconfig" },
        config = function()
            -- Carichiamo lspconfig
            require("lspconfig")
            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            -- Funzione on_attach condivisa
            local on_attach = function(client, bufnr)
                local nmap = function(keys, func, desc)
                    vim.keymap.set('n', keys, func, { buffer = bufnr, noremap = true, silent = true, desc = 'LSP: ' .. desc })
                end
                nmap('gd', vim.lsp.buf.definition, '[G]o to [D]efinizione')
                nmap('K', vim.lsp.buf.hover, 'Documentazione Hover')
                nmap('gi', vim.lsp.buf.implementation, '[G]o to [I]mplementazione')
                nmap('<leader>rn', vim.lsp.buf.rename, '[R]i[n]omina')
                nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
                nmap('gr', vim.lsp.buf.references, '[G]o to [R]eferenze')
                nmap('<leader>e', vim.diagnostic.open_float, 'Mostra diagnostica di linea')

                if client.server_capabilities.inlayHintProvider then
                    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
                end
            end

            -- === HELPER SETUP NVIM 0.11 ===
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

            -- Setup di Mason-LSPConfig
            require('mason-lspconfig').setup({
                ensure_installed = {
                    "yamlls",
                    "cssls",
                    "pyright",
                    "vue-language-server", 
                    "ts_ls",
                    "dockerls",
                    "texlab",
                },
                automatic_installation = false,
                automatic_enable = {
                    exclude = { "vue_ls", "ts_ls", "yamlls", "cssls", "pyright" }
                },
            })

            -- === SETUP SERVER ===

            setup_server("yamlls", {})
            setup_server("cssls", {})
            setup_server("pyright", {})

            setup_server("vue_ls", {
                init_options = {
                    vue = {
                        hybridMode = true
                    },
                },
            })

            -- Configurazione TYPESCRIPT (ts_ls)
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
                    on_attach(client, bufnr)  -- Chiama il tuo on_attach base

                    -- Disabilita inlay hints per file JavaScript e Vue con JS
                    local filetype = vim.bo[bufnr].filetype
                    if filetype == "javascript" or filetype == "vue" then
                        vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
                    end
                end,
            })

            setup_server("texlab", {
                settings = {
                    texlab = {
                        build = {
                            onSave = true, -- Compila automaticamente quando salvi
                            forwardSearchAfter = true, -- Porta il PDF alla riga corrente dopo il build
                        },
                        chktex = {
                            onOpenAndSave = true, -- Controllo errori grammaticali/stile (se hai chktex installato)
                        },
                    }
                }
            })
        end,
    },

    -- NVIM-CMP
    {
        "hrsh7th/nvim-cmp",
        dependencies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path", "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip", "onsails/lspkind.nvim" },
        config = function()
            local cmp = require('cmp')
            local luasnip = require('luasnip')
            local lspkind = require('lspkind')
            cmp.setup({
                formatting = { format = lspkind.cmp_format({ mode = 'text', maxwidth = 50, ellipsis_char = '...' }) },
                snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
                sources = { { name = 'nvim_lsp' }, { name = 'luasnip' }, { name = 'buffer' }, { name = 'path' } },
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
                }),
            })
        end,
    },

    -- TREESITTER
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        opts = {
            ensure_installed = { "vue", "javascript", "typescript", "go", "python", "css", "html", "yaml", "lua", "vim", "latex" },
            sync_install = false,
            auto_install = true,
            highlight = { enable = true, disable = { "tsx" } },
            indent = { enable = true },
        },
    },
}
