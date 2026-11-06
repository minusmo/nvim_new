return {
  "stevearc/aerial.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    {
      "<leader>o",
      "<Cmd>AerialToggle<CR>",
      desc = "Show document symbols",
    },
  },
  opts = {
    -- Treesitter is not installed. Use the language server.
    backends = { "lsp", "markdown", "man" },
  },
}
