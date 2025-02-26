return {
  "folke/snacks.nvim",
  ---@type snacks.Config

  ---@class snacks.dashboard.Config
  ---@field enabled? boolean
  ---@field sections snacks.dashboard.Section
  ---@field formats table<string, snacks.dashboard.Text|fun(item:snacks.dashboard.Item, ctx:snacks.dashboard.Format.ctx):snacks.dashboard.Text>

  opts = {
    dashboard = {
      enabled = true,

      width = 60,
      row = nil, -- dashboard position. nil for center
      col = nil, -- dashboard position. nil for center
      pane_gap = 4, -- empty columns between vertical panes
      autokeys = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", -- autokey sequence
      -- These settings are used by some built-in sections
      preset = {
        -- Defaults to a picker that supports `fzf-lua`, `telescope.nvim` and `mini.pick`
        ---@type fun(cmd:string, opts:table)|nil
        pick = nil,
        ---@type snacks.dashboard.Item[]
        keys = {
          -- { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          -- { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          -- { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          {
            icon = " ",
            key = "c",
            desc = "Config",
            action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
          },
          { icon = " ", key = "s", desc = "Restore Session", section = "session" },
          -- { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
        -- Used by the `header` section

        header = [[ 
                                                                   
      ████ ██████           █████      ██                    
     ███████████             █████                            
     █████████ ███████████████████ ███   ███████████  
    █████████  ███    █████████████ █████ ██████████████  
   █████████ ██████████ █████████ █████ █████ ████ █████  
 ███████████ ███    ███ █████████ █████ █████ ████ █████ 
██████  █████████████████████ ████ █████ █████ ████ ██████
        ]],
        terminal = {},
        recent_files = {},
      },
      -- item field formatters
      formats = {
        icon = function(item)
          local devicons = require("nvim-web-devicons")
          if item.file and (item.icon == "file" or item.icon == "directory") then
            local icon, hl = devicons.get_icon(item.file, item.icon == "directory")
            if icon then
              return {
                icon,
                width = 2,
                hl = "icon",
              }
            else
              return {
                "󰈔", -- Default icon
                width = 2,
                hl = "icon",
              }
            end
          end
          return { item.icon, width = 2, hl = "icon" }
        end,

        footer = { "%s", align = "center" },
        header = { "%s", align = "center", hl = "Keyword" },
        file = function(item, ctx)
          local fname = vim.fn.fnamemodify(item.file, ":~")
          fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
          if #fname > ctx.width then
            local dir = vim.fn.fnamemodify(fname, ":h")
            local file = vim.fn.fnamemodify(fname, ":t")
            if dir and file then
              file = file:sub(-(ctx.width - #dir - 2))
              fname = dir .. "/…" .. file
            end
          end
          local dir, file = fname:match("^(.*)/(.+)$")
          return dir and { { dir .. "/", hl = "dir" }, { file, hl = "file" } } or { { fname, hl = "file" } }
        end,
      },
      sections = {
        -- {
        --   section = "header",
        -- },
        {
          section = "terminal",
          cmd = "colorscript -e crunch | lolcat",
          -- cmd = "colorscript -e crunchbang-mini | lolcat",
          -- cmd = "colorscript -e crunchbang | lolcat",
          height = 12,
          width = 60,
          row = 10,
          -- col = 10,
        },
        { section = "recent_files", cwd = false, limit = 3, padding = 1 },
        { section = "keys", gap = 0, padding = 1 },
        { section = "startup" },
      },
    },
  },
}
