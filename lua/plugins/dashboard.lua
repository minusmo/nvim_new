return {
  "nvimdev/dashboard-nvim",
  event = "VimEnter",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("dashboard").setup({
      theme = "hyper",
      config = {
        week_header = {
          enable = true,
        },
        shortcut = {
          {
            desc = "New file",
            group = "DiagnosticHint",
            key = "n",
            action = function()
              vim.cmd("enew")
            end,
          },
          {
            desc = "Lazy",
            group = "Number",
            key = "l",
            action = function()
              vim.cmd("Lazy")
            end,
          },
          {
            desc = "Config",
            group = "@property",
            key = "c",
            action = function()
              vim.cmd.edit(vim.fn.stdpath("config") .. "/init.lua")
            end,
          },
          {
            desc = "Explorer",
            group = "Directory",
            key = "e",
            action = function()
              require("neo-tree.command").execute({
                action = "focus",
                dir = vim.uv.cwd(),
              })
            end,
          },
          {
            desc = "Buffers",
            group = "String",
            key = "b",
            action = function()
              require("telescope.builtin").buffers({ sort_mru = true })
            end,
          },
          {
            desc = "Quit",
            group = "Label",
            key = "q",
            action = function()
              vim.cmd("qa")
            end,
          },
        },
        project = {
          enable = true,
          limit = 8,
          action = function(path)
            require("neo-tree.command").execute({
              action = "focus",
              dir = path,
            })
          end,
        },
        mru = {
          limit = 10,
        },
      },
    })
  end,
}
