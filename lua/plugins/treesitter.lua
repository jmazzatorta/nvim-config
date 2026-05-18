return {

    -- === TREESITTER ===

    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            local nts = require("nvim-treesitter")

            nts.install({
                "vue", "javascript", "typescript", "go", "python", "css", "html",
                "yaml", "lua", "vim", "vimdoc", "markdown", "markdown_inline",
                "haskell", "bash",
            })

            local ts_filetypes = {
                "vue", "javascript", "typescript", "javascriptreact", "typescriptreact",
                "go", "python", "css", "html", "yaml", "lua", "vim", "help",
                "markdown", "haskell", "bash", "sh",
            }

            vim.api.nvim_create_autocmd("FileType", {
                pattern = ts_filetypes,
                callback = function(args)
                    local bufnr = args.buf
                    pcall(vim.treesitter.start, bufnr)
                    if type(nts.indentexpr) == "function" then
                        vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                    end
                end,
            })
        end,
    },
}
