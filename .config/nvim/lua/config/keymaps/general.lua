local M = {}

function M.setup()
  vim.keymap.set("n", "J", "mzJ`z", { desc = "Merge lines (preserve cursor)" })
  vim.keymap.set("n", "n", "nzzzv", { desc = "Search next (centered)" })
  vim.keymap.set("n", "N", "Nzzzv", { desc = "Search prev (centered)" })
  vim.keymap.set("n", "q:", function() end, { desc = "Disable q: typo" })
  vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })
end

return M
