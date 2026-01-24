local M = {}

function M.on_attach(client, bufnr)
  require("config.keymaps.lsp").on_attach(client, bufnr)
end

return M
