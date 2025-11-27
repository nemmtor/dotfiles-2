-- return {
--   "catppuccin/nvim",
--   config = function()
--     vim.cmd.colorscheme("catppuccin-frappe")
--   end,
-- }
return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {},
  config = function()
    vim.cmd.colorscheme("tokyonight-storm")
  end,
}
