return {
  {
    "tiagovla/tokyodark.nvim",
    opts = {
      gamma = 0.9,
      terminal_colors = true,
    },
  },
  { "navarasu/onedark.nvim", opts = {
    style = "darker",
  } },
  { "luisiacc/gruvbox-baby" },
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyodark",
    },
  },
}
