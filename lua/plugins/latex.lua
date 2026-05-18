return {

    -- === LATEX ===
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
}
