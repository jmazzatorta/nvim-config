return {

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
}
