return {
  "saghen/blink.cmp",
  opts = {
    keymap = {
      ["<Tab>"] = { "select_next", "fallback" },
      ["<S-Tab>"] = { "select_prev", "fallback" },
      ["<CR>"] = { "select_and_accept", "fallback" },
      ["<M-CR>"] = { "snippet_forward", "fallback" },
    },
    completion = {
      menu = { border = "rounded" },
      documentation = { window = { border = "rounded" } },
    },
  },
}
