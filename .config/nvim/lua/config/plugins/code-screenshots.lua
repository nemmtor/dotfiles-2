-- Make a screenshot of selected code with :CodeSnap command
return {
  "mistricky/codesnap.nvim",
  build = "make",
  enabled = false, -- TODO: enable once gh issue is fixed: https://github.com/mistricky/codesnap.nvim/issues/162
  config = function()
    require("codesnap").setup({
      watermark = "",
      has_breadcrumbs = true,
    })
  end,
}
