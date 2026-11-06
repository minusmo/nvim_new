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
            desc = "Quit",
            group = "Label",
            key = "q",
            action = function()
              vim.cmd("qa")
            end,
          },
        },
        -- Open the project directory. A file picker is not installed yet.
        project = {
          enable = true,
          limit = 8,
          action = function(path)
            vim.cmd.edit(path)
          end,
        },
        mru = {
          limit = 10,
        },
      },
    })
  end,
}
