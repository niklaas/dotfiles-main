return {
  "echasnovski/mini.nvim",
  lazy = false,
  config = function()
    require("mini.ai").setup({ n_lines = 500 })
    require("mini.icons").setup()
    require("mini.jump2d").setup()
    require("mini.operators").setup()
    require("mini.pairs").setup()
    require("mini.surround").setup()

    require("mini.extra").setup()

    local statusline = require("mini.statusline")
    statusline.setup()
    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_location = function()
      return "%2l:%-2v"
    end

    require("mini.pick").setup({
      mappings = {
        populate_command = {
          char = "<c-.>",
          func = function()
            local current_match = MiniPick.get_picker_matches().current
            local keys = vim.api.nvim_replace_termcodes(":" .. current_match .. "<c-b>", true, true, true)
            vim.fn.feedkeys(keys, "n")
            return true
          end,
        },
      },
    })
    vim.keymap.set("n", "<leader>sf", MiniPick.builtin.files, { desc = "[S]earch [F]iles" })
    vim.keymap.set("n", "<leader><leader>", MiniPick.builtin.buffers, { desc = "[ ] Find existing buffers" })
    vim.keymap.set("n", "<leader>sg", MiniPick.builtin.grep_live, { desc = "[S]earch by [G]rep" })
    vim.keymap.set("n", "<leader>sw", '<cmd>Pick grep pattern="<cword>"<cr>', { desc = "[S]earch current [W]ord" })
    vim.keymap.set("n", "<leader>sk", MiniExtra.pickers.keymaps, { desc = "[S]earch [K]eymaps" })
    vim.keymap.set("n", "<leader>sb", function()
      MiniExtra.pickers.git_branches(
        { scope = "local" },
        {
          mappings = {
            populate_command = {
              char = "<c-.>",
              func = function()
                local current_match = MiniPick.get_picker_matches().current
                local branch = current_match:sub(3):match("(%w+)")

                local keys = vim.api.nvim_replace_termcodes(":" .. branch .. "<c-b>", true, true, true)
                vim.fn.feedkeys(keys, "n")
                return true
              end,
            },
          },
        }
      )
    end, { desc = "[S]earch [B]ranches" })

    -- lsp related:
    vim.keymap.set("n", "gd", function()
      MiniExtra.pickers.lsp({ scope = "definition" })
    end, { desc = "[G]oto [D]efinition" })
    vim.keymap.set("n", "gr", function()
      MiniExtra.pickers.lsp({ scope = "references" })
    end, { desc = "[G]oto [R]eferences" })
    vim.keymap.set("n", "gI", function()
      MiniExtra.pickers.lsp({ scope = "implementation" })
    end, { desc = "[G]oto [I]mplementation" })
    vim.keymap.set("n", "<leader>D", function()
      MiniExtra.pickers.lsp({ scope = "type_definition" })
    end, { desc = "Type [D]efinition" })
    vim.keymap.set("n", "<leader>ds", function()
      MiniExtra.pickers.lsp({ scope = "document_symbol" })
    end, { desc = "[D]ocument [S]ymbols" })
    vim.keymap.set("n", "<leader>ws", function()
      MiniExtra.pickers.lsp({ scope = "workspace_symbol" })
    end, { desc = "[W]orkspace [S]ymbols" })

    vim.keymap.set("n", "<leader>sn", function()
      MiniPick.builtin.files({}, { source = { cwd = vim.fn.expand("~/git/dotfiles-main/vim/.config/nvim-ant") } })
    end, { desc = "[S]earch [n]eovim files" })
  end,
}
