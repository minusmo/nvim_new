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
    {
            "<leader>sg",
        function()
            require("telescope.builtin").live_grep()
            end,
        desc = "Live grep",
        },
        {
                "<leader>ff",
            function()
                require("telescope.builtin").find_files()
                end,
            desc = "Find files",
        },
  },
}
