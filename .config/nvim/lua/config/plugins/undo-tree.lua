return {
  "mbbill/undotree",
  keys = {
    {
      "<F3>",
      function()
        vim.cmd.UndotreeToggle()
        vim.cmd.UndotreeFocus()
      end,
      desc = "Toggle undo tree",
    },
  },
}
