return {
  "folke/trouble.nvim",
  cmd = "Trouble",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {},
  keys = {
    {
      "<leader>d",
      "<Cmd>Trouble diagnostics toggle filter.buf=0<CR>",
      desc = "Show buffer diagnostics",
    },
    {
      "<leader>D",
      "<Cmd>Trouble diagnostics toggle<CR>",
      desc = "Show workspace diagnostics",
    },
  },
}
