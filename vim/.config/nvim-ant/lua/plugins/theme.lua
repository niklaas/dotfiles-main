return {
  "catppuccin/nvim",
  lazy = false,
  name = "catppuccin",
  priority = 1000,
  config = function()
    vim.cmd.colorscheme("catppuccin")

    local light = "catppuccin-latte"
    local dark = "catppuccin-mocha"
    vim.keymap.set("n", "<leader>tt", function()
      if vim.g.colors_name == light then
        vim.cmd.colorscheme(dark)
      else
        vim.cmd.colorscheme(light)
      end
    end, { desc = "Toggle light/dark colorscheme" })
  end,
}
