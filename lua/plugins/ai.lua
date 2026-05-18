return {

    -- === COPILOT ===
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        opts = {
            suggestion = { enabled = false },
            panel = { enabled = false },
        },
    },

    -- === AVANTE AGENT w/ COPILOT ===
    {
        "yetone/avante.nvim",
        lazy = false,
        version = false,
        build = "make",
        opts = {
            provider = "copilot",
            providers = {
                copilot = {
                    -- model = "gpt-4o-2024-08-06", 
                    -- model = "claude-3.5-sonnet",
                    model = "gpt-4o-mini";
                    temperature = 0,
                    extra_request_body = {
                        max_tokens = 4096,
                    },
                },
            },
            behaviour = {
                auto_suggestions = false,
                auto_set_highlight_group = true,
                auto_set_keymaps = true,
                auto_apply_diff_after_generation = false,
                auto_approve_tool_permissions = false,
            },
            mappings = {
                ask = "<leader>aa",
                edit = "<leader>ae",
                refresh = "<leader>ar",
                focus = "<leader>af",
                toggle = {
                    default = "<leader>at",
                    debug = "<leader>ad",
                    hint = "<leader>ah",
                    suggestion = "<leader>as",
                    repomap = "<leader>am",
                },
            },
        },
        keys = {
            {
                "<leader>at",
                function()
                    vim.cmd("AvanteToggle")
                    require("avante.api").refresh()
                end,
                desc = "Toggle Avante UI & Popups",
            },
        },
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "stevearc/dressing.nvim",
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            "echasnovski/mini.icons",
            "MeanderingProgrammer/render-markdown.nvim",
        },
    },
}
