local M = {}

local show_notifications = function(opts)
  opts = opts or {}

  local ok, mini_notify = pcall(require, "mini.notify")
  if not ok then
    vim.notify("mini.notify not available", vim.log.levels.WARN)
    return
  end

  local notifications = mini_notify.get_all()

  if #notifications == 0 then
    vim.notify("No notifications", vim.log.levels.INFO)
    return
  end

  local messages = {}
  for _, notification in ipairs(notifications) do
    local message = notification.msg or "No message"
    table.insert(messages, message)
  end

  local actions = require("telescope.actions")
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local previewers = require("telescope.previewers")

  pickers
    .new(opts, {
      prompt_title = "Notifications",
      finder = finders.new_table({
        results = messages,
        entry_maker = function(message)
          -- Truncate display to first line
          local display = message:gsub("\n.*", "...")
          return {
            value = message,
            ordinal = message,
            display = display,
          }
        end,
      }),
      sorter = conf.generic_sorter(opts),
      attach_mappings = function()
        actions.select_default:replace(function(prompt_bufnr)
          local selection = require("telescope.actions.state").get_selected_entry()
          actions.close(prompt_bufnr)
          if selection then
            vim.fn.setreg("+", selection.value)
            vim.notify("Copied to clipboard", vim.log.levels.INFO)
          end
        end)
        return true
      end,
      previewer = previewers.new_buffer_previewer({
        define_preview = function(self, entry)
          if not entry or not entry.value then
            return
          end
          local lines = vim.split(entry.value, "\n", { plain = true })
          if #lines == 0 then
            lines = { "(empty)" }
          end
          vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
          vim.bo[self.state.bufnr].filetype = "markdown"
        end,
      }),
    })
    :find()
end

M.setup = function()
  vim.keymap.set("n", "<space>sn", function()
    show_notifications()
  end, { desc = "[S]how [N]otifications" })
end

return M
