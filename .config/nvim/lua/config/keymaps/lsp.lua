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
    local has_biome = false
    local clients = vim.lsp.get_clients({ bufnr = bufnr })

    for _, c in ipairs(clients) do
      if c.name == "eslint" then
        has_eslint = true
        break
      end
      if c.name == "biome" then
        has_biome = true
        break
      end
    end

    if has_eslint and vim.fn.exists(":EslintFixAll") > 0 then
      vim.cmd("EslintFixAll")
    elseif has_biome then
      vim.notify("Not doable with Biome", vim.log.levels.INFO)
    else
      vim.notify("No linter attached", vim.log.levels.WARN)
    end
  end, vim.tbl_extend("force", opts, { desc = "Lint fix all" }))

  -- LSP navigation (via telescope)
  local ok, builtin = pcall(require, "telescope.builtin")
  if ok then
    vim.keymap.set("n", "gr", builtin.lsp_references, vim.tbl_extend("force", opts, { desc = "References" }))
    vim.keymap.set("n", "gd", builtin.lsp_definitions, vim.tbl_extend("force", opts, { desc = "Definition" }))
    vim.keymap.set("n", "gi", builtin.lsp_implementations, vim.tbl_extend("force", opts, { desc = "Implementation" }))
    vim.keymap.set("n", "gt", builtin.lsp_type_definitions, vim.tbl_extend("force", opts, { desc = "Type definition" }))
  end
end

return M
