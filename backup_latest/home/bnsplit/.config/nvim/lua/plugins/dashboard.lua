return {
  "nvimdev/dashboard-nvim",
  event = "VimEnter",
  config = function()
    require("dashboard").setup({
      theme = "doom",
      config = {
        week_header = {
          enable = true,
        },
        header = {
          "                                                                    ",
          "                                                                    ",
          "                                                                    ",
          "                                                                    ",
          "       ████ ██████           █████      ██                    ",
          "      ███████████             █████                            ",
          "      █████████ ███████████████████ ███   ███████████  ",
          "     █████████  ███    █████████████ █████ ██████████████  ",
          "    █████████ ██████████ █████████ █████ █████ ████ █████  ",
          "  ███████████ ███    ███ █████████ █████ █████ ████ █████ ",
          " ██████  █████████████████████ ████ █████ █████ ████ ██████",
          "                                                                    ",
          "                                                                    ",
          "                                                                    ",
        },
        center = {
          {
            icon = " ",
            icon_hl = "Title",
            desc = "Find File                                      ",
            desc_hl = "String",
            key = "f",
            key_format = " %s", -- remove default surrounding `[]`
            key_hl = "Number",
            action = "lua LazyVim.pick()()",
          },
          {
            icon = " ",
            icon_hl = "Title",
            desc = "New File",
            desc_hl = "String",
            key = "n",
            key_format = " %s", -- remove default surrounding `[]`
            key_hl = "Number",
            action = "ene | startinsert",
          },
          {
            icon = " ",
            icon_hl = "Title",
            desc = "Recent Files",
            desc_hl = "String",
            key = "r",
            key_format = " %s", -- remove default surrounding `[]`
            key_hl = "Number",
            action = 'lua LazyVim.pick("oldfiles")()',
          },
          {
            icon = " ",
            icon_hl = "Title",
            desc = "Find Text",
            desc_hl = "String",
            key = "g",
            key_format = " %s", -- remove default surrounding `[]`
            key_hl = "Number",
            action = 'lua LazyVim.pick("live_grep")()',
          },
          {
            icon = " ",
            icon_hl = "Title",
            desc = "Config",
            desc_hl = "String",
            key = "c",
            key_format = " %s", -- remove default surrounding `[]`
            key_hl = "Number",
            action = "lua LazyVim.pick.config_files()()",
          },
          {
            icon = " ",
            icon_hl = "Title",
            desc = "Restore Session",
            desc_hl = "String",
            key = "s",
            key_format = " %s", -- remove default surrounding `[]`
            key_hl = "Number",
            action = 'lua require("persistence").load()',
          },
          {
            icon = " ",
            icon_hl = "Title",
            desc = "Lazy Extras",
            desc_hl = "String",
            key = "x",
            key_format = " %s", -- remove default surrounding `[]`
            key_hl = "Number",
            action = "LazyExtras",
          },
          {
            icon = "󰒲 ",
            icon_hl = "Title",
            desc = "Lazy",
            desc_hl = "String",
            key = "l",
            key_format = " %s", -- remove default surrounding `[]`
            key_hl = "Number",
            action = "Lazy",
          },
          {
            icon = " ",
            icon_hl = "Title",
            desc = "Quit",
            desc_hl = "String",
            key = "q",
            key_format = " %s", -- remove default surrounding `[]`
            key_hl = "Number",
            action = function()
              vim.api.nvim_input("<cmd>qa<cr>")
            end,
          },
        },
        -- shortcut = {
        --   { desc = "󰊳 Update", group = "@property", action = "Lazy update", key = "u" },
        --   {
        --     icon = " ",
        --     icon_hl = "@variable",
        --     desc = "Files",
        --     group = "Label",
        --     action = "lua LazyVim.pick()()",
        --     key = "f",
        --   },
        --   {
        --     desc = " Recent Files",
        --     group = "DiagnosticHint",
        --     action = "lua LazyVim.pick('oldfiles')()",
        --     key = "r",
        --   },
        --   {
        --     desc = " Config",
        --     group = "Number",
        --     action = "lua LazyVim.pick.config_files()()",
        --     key = "c",
        --   },
        --   {
        --     desc = " Quit",
        --     group = "@property",
        --     action = function()
        --       vim.api.nvim_input("<cmd>qa<cr>")
        --     end,
        --     key = "q",
        --   },
        -- },
      },
    })
  end,
  dependencies = { { "nvim-tree/nvim-web-devicons" } },
}
