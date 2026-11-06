return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    -- Space is a built-in motion, so which-key will not open on <leader> by itself.
    triggers = {
      { "<auto>", mode = "nxso" },
      { "<leader>", mode = { "n", "v" } },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show()
      end,
      desc = "Show keymaps",
    },
  },
}
