return {

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
}
