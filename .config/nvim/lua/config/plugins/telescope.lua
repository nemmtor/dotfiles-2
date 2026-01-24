return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
    "nvim-telescope/telescope-live-grep-args.nvim",
  },
  keys = {
    {
      "<space>sf",
      function()
        require("telescope.builtin").find_files()
      end,
      desc = "Find files",
    },
    {
      "<space>sh",
      function()
        require("telescope.builtin").help_tags()
      end,
      desc = "Help tags",
    },
    {
      "<space>sc",
      function()
        require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
      end,
      desc = "Search config",
    },
    {
      "<space>sp",
      function()
        require("telescope.builtin").find_files({ cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy") })
      end,
      desc = "Search plugins",
    },
    {
      "<space>sr",
      function()
        require("telescope.builtin").resume()
      end,
      desc = "Resume picker",
    },
    {
      "<space>sch",
      function()
        require("telescope.builtin").command_history()
      end,
      desc = "Command history",
    },
    {
      "<space>ssh",
      function()
        require("telescope.builtin").search_history()
      end,
      desc = "Search history",
    },
    {
      "<space>sth",
      function()
        require("telescope.builtin").pickers()
      end,
      desc = "Picker history",
    },
    {
      "<space>?",
      function()
        require("telescope.builtin").oldfiles()
      end,
      desc = "Recent files",
    },
    {
      "<space>sg",
      function()
        require("telescope").extensions.live_grep_args.live_grep_args()
      end,
      desc = "Live grep",
    },
    {
      "<space>swu",
      function()
        require("telescope-live-grep-args.shortcuts").grep_word_under_cursor()
      end,
      desc = "Grep word under cursor",
    },
    {
      "<space>ssu",
      function()
        require("telescope-live-grep-args.shortcuts").grep_visual_selection()
      end,
      mode = "v",
      desc = "Grep selection",
    },
  },
  config = function()
    local telescope = require("telescope")
    telescope.setup({
      defaults = {
        cache_picker = {
          num_pickers = 25,
        },
      },
      pickers = {
        find_files = {
          theme = "ivy",
        },
      },
      extensions = {
        fzf = {},
      },
    })
    telescope.load_extension("fzf")
    telescope.load_extension("live_grep_args")

    require("config.telescope.notifications").setup()
  end,
}
