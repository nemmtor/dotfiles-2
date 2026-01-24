local M = {}

M.capabilities = require("config.lsp.capabilities")
M.on_attach = require("config.lsp.on_attach")

-- Server configs (without capabilities - added at setup time)
M.servers = {
  lua_ls = require("config.lsp.servers.lua"),
  tailwindcss = require("config.lsp.servers.tailwind"),
  biome = require("config.lsp.servers.biome"),
  clangd = require("config.lsp.servers.clangd"),
}

function M.setup_servers()
  local caps = M.capabilities.get()
  local vim_lspconfig = vim.lsp.config

  for name, config in pairs(M.servers) do
    -- Merge capabilities at setup time (when blink.cmp is available)
    local merged = vim.tbl_deep_extend("force", { capabilities = caps }, config)
    vim_lspconfig(name, merged)
  end
end

return M
