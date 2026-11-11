local servers = {
  lua_ls = "lua-language-server",
  gopls = "gopls",
  rust_analyzer = "rust-analyzer",
  clangd = "clangd",
  ty = "ty",
  ruff = "ruff",
}

-- Inlay hints: LSP-provided labels drawn inline at call sites, e.g.
-- `connect(host: "a", port: 80)`, so you can read which argument is which
-- without opening the declaration.
--
-- How to turn them off:
--   * Permanently: set ENABLE_INLAY_HINTS to false below.
--   * Until you quit Neovim: run `:lua vim.lsp.inlay_hint.enable(false)`
--     (`:lua vim.lsp.inlay_hint.enable(true)` turns them back on).
--   * Only the current buffer:
--     `:lua vim.lsp.inlay_hint.enable(false, { bufnr = 0 })`
-- To hide just one language, remove its hint settings in the config() below
-- (lua_ls, gopls) or switch them off in that server's own settings.
local ENABLE_INLAY_HINTS = true

-- Highlight every read/write of the symbol under the cursor using LSP
-- textDocument/documentHighlight. Colours come from LspReferenceText/Read/Write
-- (see colors/monochrome.lua).
local HIGHLIGHT_DELAY_MS = 150
local reference_state = {} -- bufnr -> { timer = uv_timer, seq = integer }

local function detach_reference_highlight(buf)
  local state = reference_state[buf]
  if not state then
    return
  end
  reference_state[buf] = nil
  state.timer:stop()
  state.timer:close()
  pcall(vim.api.nvim_del_augroup_by_name, "lsp_reference_highlight_" .. buf)
  if vim.api.nvim_buf_is_valid(buf) then
    vim.lsp.util.buf_clear_references(buf)
  end
end

local function attach_reference_highlight(buf)
  if reference_state[buf] then
    return -- another client already enabled it for this buffer
  end

  local timer = assert(vim.uv.new_timer())
  -- `seq` is bumped whenever the highlight is cleared, so a response to a
  -- request sent before the cursor moved is dropped instead of painted.
  local state = { timer = timer, seq = 0 }
  reference_state[buf] = state

  local function clear()
    state.seq = state.seq + 1
    timer:stop()
    vim.lsp.util.buf_clear_references(buf)
  end

  local function request()
    if not vim.api.nvim_buf_is_valid(buf) or vim.api.nvim_get_current_buf() ~= buf or vim.fn.mode() ~= "n" then
      return
    end
    local seq = state.seq
    local win = vim.api.nvim_get_current_win()
    vim.lsp.buf_request(buf, "textDocument/documentHighlight", function(client)
      return vim.lsp.util.make_position_params(win, client.offset_encoding)
    end, function(_, result, ctx)
      local client = vim.lsp.get_client_by_id(ctx.client_id)
      if not result or not client or seq ~= state.seq or not vim.api.nvim_buf_is_valid(buf) then
        return
      end
      vim.lsp.util.buf_highlight_references(buf, result, client.offset_encoding)
    end)
  end

  local fire = vim.schedule_wrap(request)
  local group = vim.api.nvim_create_augroup("lsp_reference_highlight_" .. buf, { clear = true })

  vim.api.nvim_create_autocmd({ "CursorMoved", "InsertLeave" }, {
    group = group,
    buffer = buf,
    callback = function()
      clear()
      timer:start(HIGHLIGHT_DELAY_MS, 0, fire)
    end,
  })
  vim.api.nvim_create_autocmd({ "InsertEnter", "BufLeave" }, {
    group = group,
    buffer = buf,
    callback = clear,
  })
  vim.api.nvim_create_autocmd("LspDetach", {
    group = group,
    buffer = buf,
    callback = function(args)
      -- Keep it alive while another attached client still supports highlights.
      for _, client in ipairs(vim.lsp.get_clients({ bufnr = buf, method = "textDocument/documentHighlight" })) do
        if client.id ~= args.data.client_id then
          return
        end
      end
      detach_reference_highlight(buf)
    end,
  })
end

return {
  "neovim/nvim-lspconfig",
  dependencies = { "saghen/blink.cmp" },
  lazy = false,
  config = function()
    -- Recognize the Neovim runtime when editing this config.
    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          -- lua_ls ships with hints off; show argument names only.
          hint = { enable = true, paramName = "All", paramType = false, arrayIndex = "Disable" },
        },
      },
      on_init = function(client)
        local path = client.workspace_folders and client.workspace_folders[1].name
        if
          path
          and path ~= vim.fn.stdpath("config")
          and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
        then
          return
        end

        client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
          runtime = {
            version = "LuaJIT",
            path = {
              "lua/?.lua",
              "lua/?/init.lua",
            },
          },
          workspace = {
            checkThirdParty = false,
            library = {
              vim.env.VIMRUNTIME,
            },
          },
        })
      end,
    })

    -- gopls also ships with hints off; ask it for argument names only.
    vim.lsp.config("gopls", {
      settings = { gopls = { hints = { parameterNames = true } } },
    })

    vim.lsp.inlay_hint.enable(ENABLE_INLAY_HINTS)

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("lsp_reference_highlight", { clear = true }),
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client:supports_method("textDocument/documentHighlight", args.buf) then
          attach_reference_highlight(args.buf)
        end
      end,
    })

        for name, bin in pairs(servers) do
            if vim.fn.executable(bin) == 1 then
                vim.lsp.enable(name)
            end
        end

        vim.keymap.set("n", "gd", vim.lsp.buf.definition, {
          desc = "Goto Definition",
        })
        vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, {
          desc = "Goto Type Definition",
        })
        vim.keymap.set("n", "gI", vim.lsp.buf.implementation, {
          desc = "Goto Implementation",
        })
        vim.keymap.set("n", "gr", vim.lsp.buf.references, {
          desc = "References",
        })
  end,
}
