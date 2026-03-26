local M = {}

function M.on_attach(client, bufnr)
  local opts = { buffer = bufnr }

  -- Hover and diagnostics
  vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover" }))
  vim.keymap.set("n", "[d", function()
    vim.diagnostic.jump({ count = -1, float = true })
  end, vim.tbl_extend("force", opts, { desc = "Prev diagnostic" }))
  vim.keymap.set("n", "]d", function()
    vim.diagnostic.jump({ count = 1, float = true })
  end, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))

  -- Inlay hints
  vim.keymap.set("n", "<space>tih", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
  end, vim.tbl_extend("force", opts, { desc = "Toggle inlay hints" }))

  -- LSP actions
  vim.keymap.set("n", "<space>lr", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename" }))
  vim.keymap.set("n", "<space>la", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
  vim.keymap.set("n", "<space>lc", function()
    local has_eslint = false
    local clients = vim.lsp.get_clients({ bufnr = bufnr })

    for _, c in ipairs(clients) do
      if c.name == "eslint" then
        has_eslint = true
        break
      end
    end

    if has_eslint and vim.fn.exists(":EslintFixAll") > 0 then
      vim.cmd("EslintFixAll")
    else
      vim.notify("No linter attached", vim.log.levels.WARN)
    end
  end, vim.tbl_extend("force", opts, { desc = "Lint fix all" }))

  -- LSP navigation (via snacks picker)
  vim.keymap.set("n", "gr", function() Snacks.picker.lsp_references() end, vim.tbl_extend("force", opts, { desc = "References" }))
  vim.keymap.set("n", "gd", function() Snacks.picker.lsp_definitions() end, vim.tbl_extend("force", opts, { desc = "Definition" }))
  vim.keymap.set("n", "gi", function() Snacks.picker.lsp_implementations() end, vim.tbl_extend("force", opts, { desc = "Implementation" }))
  vim.keymap.set("n", "gt", function() Snacks.picker.lsp_type_definitions() end, vim.tbl_extend("force", opts, { desc = "Type definition" }))
end

return M
