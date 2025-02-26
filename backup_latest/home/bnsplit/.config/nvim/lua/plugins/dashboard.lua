return {
  "nvimdev/dashboard-nvim",
  event = "VimEnter",
  config = function()
    require("dashboard").setup({
      theme = "hyper",
      preview = {},
      shortcut = {},
      packages = {},
      project = {},
      mru = {},
      config = {
        week_header = {
          enable = true,
        },
        shortcut = {},
        packages = {},
        project = {},
        mru = {},
        header = {},
        -- header = {
        --   "                                                                    ",
        --   "                                                                    ",
        --   "                                                                    ",
        --   "                                                                    ",
        --   "       ████ ██████           █████      ██                    ",
        --   "      ███████████             █████                            ",
        --   "      █████████ ███████████████████ ███   ███████████  ",
        --   "     █████████  ███    █████████████ █████ ██████████████  ",
        --   "    █████████ ██████████ █████████ █████ █████ ████ █████  ",
        --   "  ███████████ ███    ███ █████████ █████ █████ ████ █████ ",
        --   " ██████  █████████████████████ ████ █████ █████ ████ ██████",
        --   "                                                                    ",
        --   "                                                                    ",
        --   "                                                                    ",
        -- },
        center = {},
        footer = {},
      },
    })
  end,
  dependencies = { { "nvim-tree/nvim-web-devicons" } },
}
