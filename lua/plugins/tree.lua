return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        enabled = false,
    },

    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        keys = {
            {
                "<leader>n",
                function()
                    local api = require("nvim-tree.api")
                    local current_ft = vim.bo.filetype

                    if current_ft == "NvimTree" then
                        api.tree.toggle()
                    else
                        api.tree.focus()
                    end
                end,
                desc = "Toggle Tree",
            },
        },
        config = function()
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1
            vim.opt.termguicolors = true

            require("nvim-tree").setup({
                view = {
                    side = "right",
                    width = 30,
                    number = false,
                    relativenumber = false,
                },
                sort = {
                    sorter = "case_sensitive",
                },
                renderer = {
                    group_empty = true,
                },
                filters = {
                    dotfiles = false,
                },
                git = {
                    enable = true,
                    ignore = false,
                },
            })
        end,
    },
}
