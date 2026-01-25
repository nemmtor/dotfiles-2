local M = {}

M.dap = require("config.keymaps.dap")
M.general = require("config.keymaps.general")
M.lsp = require("config.keymaps.lsp")

function M.setup()
  M.general.setup()
  -- LSP keymaps are set via on_attach, not here
end

return M
