return {
  "windwp/nvim-ts-autotag",
  event = "InsertEnter",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  opts = {
    opts = {
      enable_close = true, -- <div> -> <div></div>
      enable_rename = true, -- rename the paired tag together
      enable_close_on_slash = false,
    },
  },
}
