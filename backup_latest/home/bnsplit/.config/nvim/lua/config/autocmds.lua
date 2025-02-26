-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "oil",
--   callback = function()
--     vim.cmd("<C-p>")
--   end,
-- })

-- Hyprlang LSP
vim.filetype.add({
  pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
})
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = { "*.hl", "hypr*.conf" },
  callback = function(event)
    print(string.format("starting hyprls for %s", vim.inspect(event)))
    vim.lsp.start({
      name = "hyprlang",
      cmd = { "hyprls" },
      root_dir = vim.fn.getcwd(),
    })
  end,
})

-- show cursor line only in active window
vim.api.nvim_create_autocmd({ "FileType", "BufEnter", "BufWinEnter" }, {
  pattern = { "snacks_dashboard", "alpha" },
  callback = function()
    vim.wo.cursorline = false
    vim.w.cursorline = false
    vim.w.auto_cursorline = nil
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "alpha",
  desc = "Hide cursor and setup restore for alpha",
  callback = function()
    local alpha_buf = vim.api.nvim_get_current_buf()

    -- Save original cursor settings
    local original_hl = vim.api.nvim_get_hl(0, { name = "Cursor", link = false })
    local original_blend = original_hl.blend or 0
    local original_guicursor = vim.opt.guicursor:get()

    -- Apply alpha-specific modifications
    vim.api.nvim_set_hl(0, "Cursor", { blend = 100 })
    vim.opt.guicursor:append("a:Cursor/lCursor")

    -- Create buffer-local autocommand to restore settings
    vim.api.nvim_create_autocmd("BufUnload", {
      buffer = alpha_buf,
      desc = "Restore cursor after alpha closes",
      once = true, -- Ensure this only runs once
      callback = function()
        -- Restore cursor highlight
        vim.api.nvim_set_hl(0, "Cursor", { blend = original_blend })

        -- Restore guicursor (using original value)
        vim.opt.guicursor = original_guicursor
      end,
    })
  end,
})
