return {
  "echasnovski/mini.nvim",
  lazy = false,
  config = function()
    require("mini.ai").setup({ n_lines = 500 })
    require("mini.operators").setup()
    require("mini.surround").setup() -- todo: or tpope's surround for compatibility?

    local statusline = require("mini.statusline")
    statusline.setup({ use_icons = true })

    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_location = function()
      return "%2l:%-2v"
    end
  end,
}
