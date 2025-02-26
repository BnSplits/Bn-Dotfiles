-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>e", "<CMD>Oil --float<CR>", { desc = "Open oil" })
vim.keymap.set("n", "-", "<CMD>Oil --float<CR>", { desc = "Open oil" })
vim.keymap.set("n", "<leader>;", function()
  -- vim.cmd("lua Snacks.dashboard()")
  -- vim.cmd("Alpha")
  -- vim.cmd("Dashboard")
end, { desc = "Toggle Alpha" })
vim.keymap.set("n", "<leader>h", function()
  vim.cmd("nohlsearch")
  vim.cmd("echo 'Highlights clear'")
end, { desc = "Clear highlights" })
vim.keymap.set("n", "<leader>qq", "<CMD>quit<CR>", { desc = "Quit focused buffer" })
vim.keymap.set("n", "<leader><S-q>", "<CMD>quitall<CR>", { desc = "Quit all" })
vim.keymap.set("n", "<leader>b<S-w>", "<CMD>write<CR>", { desc = "Save focused buffer" })
vim.keymap.set("n", "<leader>bw", "<CMD>wa<CR>", { desc = "Save all buffers" })
vim.keymap.set("n", "<leader>\\", "<CMD>split<CR>", { desc = "Split Window Below" })
