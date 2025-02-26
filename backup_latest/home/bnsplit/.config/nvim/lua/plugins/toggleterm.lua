return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup({
      shell = "zsh",
      start_in_insert = true,
      float_opts = {
        border = "curved",
        title_pos = "left",
      },
      direction = "float",
      autochdir = true,
      shade_terminals = false,
    })

    -- <C-t> - Toggle main terminal
    vim.keymap.set({ "n", "v", "t" }, "<C-t>", "<cmd>1ToggleTerm direction=float name=Main <cr>", {
      desc = "Toggle main terminal",
      silent = true,
      noremap = true,
    })

    -- <leader>tr - Run in kitty with persistent window
    vim.keymap.set({ "n", "v" }, "<leader>tr", function()
      local current_file = vim.api.nvim_buf_get_name(0)
      local cmd = string.format(
        'kitty --class float-nvim-runner sh -c \'~/.config/bnsplit/scripts/code_run.sh "%s"; echo; echo -n "Press enter to exit... "; read -n 1 -s -r && exit || echo; echo -n "Command failed (status $?). Press enter to exit... "; read -n 1 -s -r && exit\' &',
        current_file:gsub("'", "'\\''")
      )
      vim.fn.system(cmd)
    end, {
      desc = "Run in kitty floating runner (persistent)",
      silent = true,
      noremap = true,
    })
  end,
}
