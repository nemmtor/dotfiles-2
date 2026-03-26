return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    input = { enabled = true },
    notifier = { enabled = true },
    picker = { enabled = true, ui_select = true },
  },
  keys = {
    { "<space>sf", function() Snacks.picker.files() end, desc = "Find files" },
    { "<space>sh", function() Snacks.picker.help() end, desc = "Help tags" },
    { "<space>sc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Search config" },
    { "<space>sp", function() Snacks.picker.files({ cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy") }) end, desc = "Search plugins" },
    { "<space>sr", function() Snacks.picker.resume() end, desc = "Resume picker" },
    { "<space>sch", function() Snacks.picker.command_history() end, desc = "Command history" },
    { "<space>ssh", function() Snacks.picker.search_history() end, desc = "Search history" },
    { "<space>?", function() Snacks.picker.recent() end, desc = "Recent files" },
    { "<space>sg", function() Snacks.picker.grep() end, desc = "Live grep" },
    { "<space>swu", function() Snacks.picker.grep_word() end, desc = "Grep word under cursor" },
    { "<space>ssu", function() Snacks.picker.grep_word() end, mode = "v", desc = "Grep selection" },
    { "<space>sn", function() Snacks.picker.notifications() end, desc = "Show notifications" },
  },
}
