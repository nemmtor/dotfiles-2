local M = {}

function M.get()
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  -- Merge blink.cmp capabilities if available
  local ok, blink = pcall(require, "blink.cmp")
  if ok then
    capabilities = blink.get_lsp_capabilities(capabilities)
  end

  capabilities.general = capabilities.general or {}
  capabilities.general.positionEncodings = { "utf-16" }
  return capabilities
end

return M
