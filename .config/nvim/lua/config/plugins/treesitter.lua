return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
      { "nvim-treesitter/nvim-treesitter-context" },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          -- Enable treesitter highlighting and disable regex syntax
          pcall(vim.treesitter.start)
          -- Enable treesitter-based indentation
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
    config = function()
      require("nvim-treesitter").setup({
        -- ensure_installed = {
        --   "c",
        --   "css",
        --   "scss",
        --   "lua",
        --   "vim",
        --   "vimdoc",
        --   "query",
        --   "markdown",
        --   "markdown_inline",
        --   "javascript",
        --   "typescript",
        --   "tsx",
        --   "cpp",
        --   "bash",
        --   "cmake",
        --   "comment",
        --   "dot",
        --   "dockerfile",
        --   "editorconfig",
        --   "fish",
        --   "gitcommit",
        --   "git_config",
        --   "git_rebase",
        --   "gitignore",
        --   "go",
        --   "graphql",
        --   "html",
        --   "http",
        --   "jsdoc",
        --   "json",
        --   "make",
        --   "nginx",
        --   "nix",
        --   "ocaml",
        --   "php",
        --   "java",
        --   "kotlin",
        --   "pod",
        --   "prisma",
        --   "python",
        --   "robots",
        --   "ruby",
        --   "rust",
        --   "scala",
        --   "sql",
        --   "ssh_config",
        --   "svelte",
        --   "vue",
        --   "yaml",
        -- },
        -- auto_install = false,
      })
    end,
  },
}
