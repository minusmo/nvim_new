return {
  {
    "stevearc/aerial.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },

    opts = {
	    layout = {
		    default_direction = "prefer_right",
		    placement = "edge"
	    }
    },

    keys = {
      {
        "<leader>o",
        "<cmd>AerialToggle!<CR>",
        desc = "Toggle Aerial",
      },
    },
  },
}
