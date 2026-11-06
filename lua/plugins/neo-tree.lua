return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  lazy = false,
  config = function()
    vim.keymap.set("n", "<leader>e", function()
      local reveal_file = vim.api.nvim_buf_get_name(0)
      if reveal_file == "" then
        require("neo-tree.command").execute({
          toggle = true,
          dir = vim.uv.cwd(),
        })
        return
      end

      require("neo-tree.command").execute({
        toggle = true,
        reveal_file = reveal_file,
        reveal_force_cwd = true,
      })
    end, { desc = "Toggle file explorer" })
  end,
}
