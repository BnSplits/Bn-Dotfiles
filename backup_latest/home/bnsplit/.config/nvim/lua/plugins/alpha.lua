return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  enabled = true,
  init = false,
  opts = function()
    local dashboard = require("alpha.themes.dashboard")

    local logo_1 = {
      "                                                                    ",
      "       ████ ██████           █████      ██                    ",
      "      ███████████             █████                            ",
      "      █████████ ███████████████████ ███   ███████████  ",
      "     █████████  ███    █████████████ █████ ██████████████  ",
      "    █████████ ██████████ █████████ █████ █████ ████ █████  ",
      "  ███████████ ███    ███ █████████ █████ █████ ████ █████ ",
      " ██████  █████████████████████ ████ █████ █████ ████ ██████",
    }

    local logo_2 = {
      "       █████████████                ███████         ",
      "      █████████████                █   ██         ",
      "      ████  ███  ████████████       █████████ ",
      "     ████     ██ █  ██  █████████ ██  █ ",
      "    ████       ████ ████████      ██████████  ",
      "  █████████████ ██  ██  ██   ██ ██   ██   ",
      " ██████████████ █ ████████ ███████████  ██   ",
      " 󰹞󰹞󰹞󰹞󰹞󰹞󰹞󰹞󰹞󰹞󰹞󰹞󰹞󰹞󰹞███󰹞󰹞󰹞󰹞󰹞󰹞󰹞󰹞󰹞󰹞󰹞󰹞󰹞󰹞󰹞󰹞󰹞󰹞󰹞󰹞󰹞󰹞󰹞󰹞󰹞󰹞󰹞󰹞󰹞󰹞󰹞󰹞󰹞󰹞 ",
      "                                                        ",
      "                ██████                              ",
      "                 ███  █  █                          ",
      "                 ███ █                                ",
      "                 ████ ██ ████                 ",
      "                 ████  █  ████                 ",
      "                 ███  ██ █████                 ",
    }

    local logo_3 = {
      [[                                  __]],
      [[     ___     ___    ___   __  __ /\_\    ___ ___]],
      [[    / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\]],
      [[   /\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \]],
      [[   \ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
      [[    \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
    }
    -- dashboard.section.header.val = logo_3
    -- dashboard.section.header.val = logo_2
    dashboard.section.header.val = logo_1
    -- stylua: ignore
    dashboard.section.buttons.val = {
      dashboard.button("f", " " .. " Find file",       "<cmd> lua LazyVim.pick()() <cr>"),
      dashboard.button("n", " " .. " New file",        [[<cmd> ene <BAR> startinsert <cr>]]),
      dashboard.button("r", " " .. " Recent files",    [[<cmd> lua LazyVim.pick("oldfiles")() <cr>]]),
      dashboard.button("g", " " .. " Find text",       [[<cmd> lua LazyVim.pick("live_grep")() <cr>]]),
      dashboard.button("c", " " .. " Config",          "<cmd> lua LazyVim.pick.config_files()() <cr>"),
      dashboard.button("s", " " .. " Restore Session", [[<cmd> lua require("persistence").load() <cr>]]),
      dashboard.button("x", " " .. " Lazy Extras",     "<cmd> LazyExtras <cr>"),
      dashboard.button("l", "󰒲 " .. " Lazy",            "<cmd> Lazy <cr>"),
      dashboard.button("q", " " .. " Quit",            "<cmd> qa <cr>"),
    }
    for _, button in ipairs(dashboard.section.buttons.val) do
      button.opts.hl = "AlphaButtons"
      button.opts.hl_shortcut = "Keyword"
    end
    dashboard.section.header.opts.hl = "Keyword"
    dashboard.section.header.opts.position = "center"
    dashboard.section.buttons.opts.hl = "Error"
    dashboard.section.footer.opts.hl = "Constant"
    dashboard.opts.layout[1].val = 3
    return dashboard
  end,
  config = function(_, dashboard)
    -- Close Lazy and re-open when the dashboard is ready
    if vim.o.filetype == "lazy" then
      vim.cmd.close()
      vim.api.nvim_create_autocmd("User", {
        once = true,
        pattern = "AlphaReady",
        callback = function()
          require("lazy").show()
        end,
      })
    end

    require("alpha").setup(dashboard.opts)

    vim.api.nvim_create_autocmd("User", {
      once = true,
      pattern = "LazyVimStarted",
      callback = function()
        local stats = require("lazy").stats()
        local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
        dashboard.section.footer.val = "⚡ Nvim loaded "
          .. stats.loaded
          .. "/"
          .. stats.count
          .. " plugins in "
          .. ms
          .. "ms ⚡"
        pcall(vim.cmd.AlphaRedraw)
      end,
    })
  end,
}
