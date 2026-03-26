local M = {}

M.capabilities = require("config.lsp.capabilities")

-- Only servers with custom config
M.servers = {
  lua_ls = require("config.lsp.servers.lua"),
}

function M.setup_servers()
  local caps = M.capabilities.get()
  local vim_lspconfig = vim.lsp.config

  -- Apply capabilities globally to all servers
  vim_lspconfig("*", { capabilities = caps })

  for name, config in pairs(M.servers) do
    vim_lspconfig(name, config)
  end
end

return M
