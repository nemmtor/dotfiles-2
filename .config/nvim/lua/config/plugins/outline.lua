return {
  "hedyhli/outline.nvim",
  keys = {
    { "<F2>", function() require("outline").toggle() end, desc = "Toggle outline" },
  },
  opts = {
    outline_window = {
      position = "left",
      width = 40,
    },
  },
}
