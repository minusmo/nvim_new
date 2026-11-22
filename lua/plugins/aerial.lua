return {
  {
    "stevearc/aerial.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },

    opts = {
	layout = {
		default_direction = "float",
	},
	float = {
		border = "rounded",
		relative = "editor",
		min_height = 5,
		max_height = 0.8,
	},
	close_on_select = true,
	autojump = true,
    },

    keys = {
      {
        "<leader>o",
        "<cmd>AerialToggle float<CR>",
        desc = "Toggle Aerial",
      },
    },
  },
}
