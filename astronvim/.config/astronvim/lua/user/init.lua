return {
  mappings = {
    n = {
      ["]<space>"] = { "o<esc>k", desc = "New line below" },
      ["[<space>"] = { "O<esc>j", desc = "New line above" },
    },
  },
  polish = function()
    vim.o.splitbelow = false
  end,
}
