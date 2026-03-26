return {
  {
    "mistricky/codesnap.nvim",
    tag = "v1.6.3",
    build = "make",
    cmd = { "CodeSnap", "CodeSnapSave" },
    config = function()
      require("codesnap").setup({
        watermark = "",
        has_breadcrumbs = true,
      })
    end,
  },
}
