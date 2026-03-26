local M = {}

function M.setup()
  require("config.keymaps.general").setup()
  -- LSP keymaps are set via on_attach, not here
end

return M
