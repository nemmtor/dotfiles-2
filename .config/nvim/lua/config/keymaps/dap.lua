local M = {}

function M.setup()
  local dap = require("dap")
  local dapui = require("dapui")

  vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
  vim.keymap.set("n", "<leader>dB", function()
    dap.set_breakpoint(vim.fn.input("Condition: "))
  end, { desc = "Conditional breakpoint" })
  vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue/Start" })
  vim.keymap.set("n", "<leader>dC", function()
    -- Build debug preset then start debugger
    vim.notify("Building debug preset...")
    vim.fn.jobstart("cmake --preset debug && cmake --build --preset debug", {
      cwd = vim.fn.getcwd(),
      on_exit = function(_, code)
        if code == 0 then
          vim.schedule(function()
            vim.notify("Build succeeded, starting debugger...")
            dap.continue()
          end)
        else
          vim.schedule(function()
            vim.notify("Build failed", vim.log.levels.ERROR)
          end)
        end
      end,
    })
  end, { desc = "Build + Debug" })
  vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step into" })
  vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Step over" })
  vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "Step out" })
  vim.keymap.set("n", "<leader>dr", dap.repl.toggle, { desc = "Toggle REPL" })
  vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Toggle DAP UI" })
  vim.keymap.set("n", "<leader>dt", dap.terminate, { desc = "Terminate" })
end

return M
