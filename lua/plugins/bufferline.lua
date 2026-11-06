return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    vim.opt.termguicolors = true

    require("bufferline").setup({
      options = {
        offsets = {
          {
            filetype = "neo-tree",
            text = "Explorer",
            highlight = "Directory",
            separator = true,
          },
          {
            filetype = "aerial",
            text = "Symbols",
            highlight = "Directory",
            separator = true,
          },
        },
      },
    })

    vim.keymap.set("n", "]b", "<Cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
    vim.keymap.set("n", "[b", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Previous buffer" })
  end,
}
