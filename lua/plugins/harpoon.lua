local function harpoon()
  return require("harpoon")
end

local function jump_to(list_item, _, options)
  if list_item == nil then
    return
  end

  options = options or {}
  if options.vsplit then
    vim.cmd("vsplit")
  elseif options.split then
    vim.cmd("split")
  elseif options.tabedit then
    vim.cmd("tabedit")
  end

  vim.cmd.edit(vim.fn.fnamemodify(list_item.value, ":p"))

  local context = list_item.context or {}
  local row = context.row or 1
  local line_count = vim.api.nvim_buf_line_count(0)
  if row < 1 then
    row = 1
  elseif row > line_count then
    row = line_count
  end

  local text = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1] or ""
  local col = context.col or 0
  if col < 0 then
    col = 0
  elseif col > #text then
    col = #text
  end

  vim.api.nvim_win_set_cursor(0, { row, col })
end

return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    {
      "<leader>ha",
      function()
        harpoon():list():add()
      end,
      desc = "Mark file and line",
    },
    {
      "<leader>hr",
      function()
        harpoon():list():remove()
      end,
      desc = "Remove mark",
    },
    {
      "<leader>hm",
      function()
        harpoon().ui:toggle_quick_menu(harpoon():list())
      end,
      desc = "Show marks",
    },
    {
      "<leader>h1",
      function()
        harpoon():list():select(1)
      end,
      desc = "Jump to mark 1",
    },
    {
      "<leader>h2",
      function()
        harpoon():list():select(2)
      end,
      desc = "Jump to mark 2",
    },
    {
      "<leader>h3",
      function()
        harpoon():list():select(3)
      end,
      desc = "Jump to mark 3",
    },
    {
      "<leader>h4",
      function()
        harpoon():list():select(4)
      end,
      desc = "Jump to mark 4",
    },
    {
      "<leader>hn",
      function()
        harpoon():list():next()
      end,
      desc = "Next mark",
    },
    {
      "<leader>hp",
      function()
        harpoon():list():prev()
      end,
      desc = "Previous mark",
    },
  },
  config = function()
    local plugin = harpoon()
    plugin:setup({
      settings = {
        save_on_toggle = true,
        sync_on_ui_close = true,
      },
      default = {
        display = function(item)
          local row = item.context and item.context.row or 1
          return item.value .. ":" .. row
        end,
        -- A mark is a file and a line. The same file can be marked again on another line.
        equals = function(a, b)
          if a == nil or b == nil then
            return a == b
          end
          local a_row = a.context and a.context.row
          local b_row = b.context and b.context.row
          return a.value == b.value and a_row == b_row
        end,
        -- Keep the marked line. The default updates it whenever the buffer is left.
        BufLeave = function() end,
        select = jump_to,
      },
    })

    require("which-key").add({
      { "<leader>h", group = "Harpoon" },
    })
  end,
}
