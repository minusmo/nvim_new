return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = "Telescope",
  keys = {
    {
      "<leader>b",
      function()
        require("telescope.builtin").buffers({ sort_mru = true })
      end,
      desc = "Search open buffers",
    },
  },
}
