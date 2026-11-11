return {
  "saghen/blink.cmp",
  version = "1.*",
  ---@module "blink.cmp"
  ---@type blink.cmp.Config
  opts = {
    -- Tab / S-Tab move through the menu. Enter accepts the selected item.
    -- C-n, C-p and C-y still work. C-space opens the menu. C-e closes it.
    keymap = {
      preset = "default",
      -- Menu closed: jump to the next snippet placeholder, else insert a real Tab.
      ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      -- Nothing selected: Enter falls through and inserts a newline.
      ["<CR>"] = { "accept", "fallback" },
    },
    completion = {
      documentation = { auto_show = false },
      -- Don't preselect the first item, so a plain Enter never swaps in a
      -- completion you didn't pick. The first Tab selects the first item.
      list = { selection = { preselect = false } },
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
  opts_extend = { "sources.default" },
}
