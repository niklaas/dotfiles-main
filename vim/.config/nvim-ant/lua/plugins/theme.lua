return {
  "tinted-theming/tinted-vim",
  lazy = false,
  priority = 1000,
  config = function(_, _)
    local light = "base16-rose-pine-dawn"
    local dark = "base16-rose-pine-moon"
    vim.g.tinted_colorspace = 256
    vim.cmd.colorscheme(dark)

    vim.keymap.set("n", "<leader>tt", function()
      if vim.g.colors_name == light then
        vim.cmd.colorscheme(dark)
      else
        vim.cmd.colorscheme(light)
      end
    end, { desc = "Toggle light/dark colorscheme" })
  end,
}
