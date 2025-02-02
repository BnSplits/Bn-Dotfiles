return {
  "akinsho/toggleterm.nvim",
  version = "*",

  config = function()
    require("toggleterm").setup({
      shell = "zsh",
      float_opts = {
        border = "curved",
      },
      direction = "float",
    })

    vim.keymap.set(
      { "n", "v" },
      "<C-t>",
      ":ToggleTerm<CR>",
      { desc = "Toggle terminal", silent = true, noremap = true }
    )

    vim.keymap.set("t", "<C-t>", function()
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true), "n", true)
      vim.cmd("ToggleTerm")
    end, { desc = "Exit terminal mode or toggle terminal", silent = true, noremap = true })
  end,
}
