return {
  {
    "tpope/vim-fugitive",
    lazy = false,
    dependencies = {
      "tpope/vim-rhubarb", -- GitHub integration
    },
    keys = {
      { "<leader>gB", ":GBrowse<cr>", desc = "Git [b]rowse", mode = { "n", "v" } },
      { "<leader>gb", ":GBrowse!<cr>", desc = "Git [b]rowse yank", mode = { "n", "v" } },
      { "<leader>gc", "<cmd>Git blame<cr>", desc = "Git [c]redit" },
      { "<leader>gf", "<cmd>Git fetch<cr>", desc = "Git [f]etch" },
      { "<leader>gg", "<cmd>Git<cr>", desc = "Git status" },
      { "<leader>gj", "<cmd>Gwrite|Git commit<cr>", desc = "Git write and commit" },
      { "<leader>gw", "<cmd>Gwrite<cr>", desc = "Git write" },
    },
  },

  {
    "junegunn/gv.vim",
    lazy = false,
    keys = {
      { "<leader>gv", "<cmd>GV<cr>", desc = "Git branch [v]isualizer" },
      { "<leader>gV", "<cmd>GV!<cr>", desc = "Git branch [v]isualizer (current file)" },
      { "<leader>GG", ":GV<space>", desc = "Git branch [v]isualizer (current file)" },
    },
  },
}
