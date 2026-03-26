return {
  {
    "mason-org/mason.nvim",
    dependencies = {
      { "neovim/nvim-lspconfig" },
      { "mason-org/mason-lspconfig.nvim" },
      { "WhoIsSethDaniel/mason-tool-installer.nvim" },
      {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            { path = "lazy.nvim", words = { "LazySpec" } },
          },
        },
      },
    },
    config = function()
      require("mason").setup()

      local lsp = require("config.lsp")
      lsp.setup_servers()

      require("mason-lspconfig").setup({
        ensure_installed = {
          "eslint",
          "lua_ls",
          "marksman",
          "stylua",
          "tailwindcss",
          "vimls",
          "graphql",
        },
      })

      require("mason-tool-installer").setup({
        ensure_installed = {
          "js-debug-adapter",
          "json-lsp",
          "prettier",
        },
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then
            return
          end
          require("config.keymaps.lsp").on_attach(client, args.buf)
        end,
      })
    end,
  },
}
