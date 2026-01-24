-- Check if node is available
local function has_node()
  return vim.fn.executable("node") == 1
end

return {
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    cond = has_node,
    config = function()
      if not has_node() then
        vim.notify("TypeScript tools disabled: node not found", vim.log.levels.WARN)
        return
      end

      require("typescript-tools").setup({
        on_attach = function(client, buffer_number)
          local ok, twoslash = pcall(require, "twoslash-queries")
          if ok then
            twoslash.attach(client, buffer_number)
          end
        end,
        settings = {
          separate_diagnostic_server = true,
          publish_diagnostic_on = "insert_leave",
          jsx_close_tag = {
            enable = false,
          },
          tsserver_file_preferences = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = true,
            includeInlayVariableTypeHints = true,
            includeInlayVariableTypeHintsWhenTypeMatchesName = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayEnumMemberValueHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
          },
          tsserver_format_options = {
            insertSpaceAfterOpeningAndBeforeClosingEmptyBraces = true,
            semicolons = "insert",
          },
          complete_function_calls = true,
          include_completions_with_insert_text = true,
          code_lens = "off",
          disable_member_code_lens = true,
          tsserver_max_memory = 12288,
        },
      })

      -- TSToolsStatus command
      vim.api.nvim_create_user_command("TSToolsStatus", function()
        local clients = vim.lsp.get_clients({ name = "typescript-tools" })
        if #clients == 0 then
          vim.notify("TypeScript tools: not running", vim.log.levels.INFO)
        else
          for _, client in ipairs(clients) do
            local buffers = vim.lsp.get_buffers_by_client_id(client.id)
            vim.notify(
              string.format("TypeScript tools: running (id=%d, buffers=%d)", client.id, #buffers),
              vim.log.levels.INFO
            )
          end
        end
      end, { desc = "Show TypeScript tools status" })
    end,
  },
}
