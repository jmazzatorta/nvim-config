return {

    -- === THEME ===
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        lazy = false,
        opts = {
            flavour = "macchiato",
            transparent_background = true,
        },
        config = function(_, opts)
            require("catppuccin").setup(opts)
            vim.cmd.colorscheme("catppuccin")
        end,
    },

    -- === STATUS BAR ===
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
            "catppuccin/nvim",
        },
        event = "VeryLazy",
        opts = {
            options = {
                theme = "catppuccin-macchiato",
            },
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
                { "<leader>a", group = "AI / Avante" },
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
}
