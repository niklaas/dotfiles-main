return {
  "lewis6991/gitsigns.nvim",
  lazy = false,
  opts = {
    signs = {
      add = { text = "+" },
      change = { text = "~" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
    },
  },
  keys = {
    {
      "<leader>hh",
      function()
        require("gitsigns").stage_hunk()
      end,
      desc = "Git [H]unk stage/unstage",
      mode = { "n", "v" },
    },
    {
      "<leader>hr",
      function()
        require("gitsigns").reset_hunk()
      end,
      desc = "Git [H]unk [r]eset",
      mode = { "n", "v" },
    },
    {
      "]h",
      function()
        require("gitsigns").nav_hunk("next")
      end,
      desc = "Next hunk",
    },
    {
      "[h",
      function()
        require("gitsigns").nav_hunk("prev")
      end,
      desc = "Previous hunk",
    },
    {
      "<leader>hl",
      function()
        require("gitsigns").setloclist(0, 0)
      end,
      desc = "Git [H]unk [l]oclist",
    },
    {
      "<leader>hq",
      function()
        require("gitsigns").setqflist(0)
      end,
      desc = "Git [H]unk [q]uickfix list",
    },
  },
}
