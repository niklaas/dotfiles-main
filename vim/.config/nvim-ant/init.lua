local map = vim.keymap.set
local o = vim.opt

vim.g.mapleader = " "
vim.g.maplocalleader = " "

o.breakindent = true
o.cursorline = true
o.inccommand = "split"
o.list = true
o.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
o.mouse = "a"
o.number = true
o.scrolloff = 3
o.signcolumn = "yes"
o.undofile = true

o.ignorecase = true
o.smartcase = true

o.updatetime = 250
o.timeoutlen = 700

vim.schedule(function()
  o.clipboard = "unnamedplus"
end)

map({ "n", "v" }, ";", ":") -- switch to command mode without pressing shift
map("c", ";", function() -- double-tap ; to list the previous commands
  if vim.fn.getcmdpos() == 1 then
    return "<C-c>q:"
  else
    return ";"
  end
end, { expr = true })

map("n", "<c-s>", "<cmd>:w<cr>")
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
map("t", "<c-enter>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

map("n", "gh", "_", { desc = "Jump to beginning of line" })
map("n", "gl", "$", { desc = "Jump to end of line" })

-- window movement
map("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

map("c", "@@", "@{upstream}", { expr = false })

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- install `lazy.nvim` plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    error("Error cloning lazy.nvim:\n" .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  change_detection = { enabled = true, notify = false },
  defaults = { lazy = true },
  spec = { import = "plugins" },
})

-- vim: ts=2 sts=2 sw=2 et
