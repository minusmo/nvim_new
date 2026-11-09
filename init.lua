vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("config.lazy")

vim.opt.number = true
vim.opt.relativenumber = true
pcall(vim.cmd, "colorscheme monochrome")

vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>", {
  desc = "Delete Buffer",
})
