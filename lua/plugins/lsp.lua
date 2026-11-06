local servers = {
  lua_ls = "lua-language-server",
  gopls = "gopls",
  rust_analyzer = "rust-analyzer",
  clangd = "clangd",
}

return {
  "neovim/nvim-lspconfig",
  dependencies = { "saghen/blink.cmp" },
  lazy = false,
  config = function()
    -- Recognize the Neovim runtime when editing this config.
    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {},
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

    for name, bin in pairs(servers) do
      if vim.fn.executable(bin) == 1 then
        vim.lsp.enable(name)
      end
    end
  end,
}
