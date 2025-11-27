return {
  {
    "marilari88/twoslash-queries.nvim",
    lazy = true,
    ft = "javascript,typescript,typescriptreact,svelte",
    config = function()
      require("twoslash-queries").setup({
        is_enabled = true,
        multi_line = true,
      })
      vim.keymap.set("n", "tsi", "<cmd>TwoslashQueriesInspect<CR>", { desc = "[T]ypescript [I]nspect" })
    end,
  },
}
