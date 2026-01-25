return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
        config = function()
          local dapui = require("dapui")
          dapui.setup()

          local dap = require("dap")
          dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
          end
          dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close()
          end
          dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
          end
        end,
      },
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
      },
      {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = { "mason-org/mason.nvim" },
        opts = {
          ensure_installed = { "js", "codelldb" },
          automatic_installation = true,
        },
      },
    },
    ft = { "javascript", "typescript", "javascriptreact", "typescriptreact", "c", "cpp" },
    keys = {
      { "<leader>d", desc = "Debug" },
    },
    config = function()
      local dap = require("dap")
      local keymaps = require("config.keymaps.dap")
      keymaps.setup()

      -- JS/TS adapter (pwa-node, pwa-chrome)
      for _, adapter in ipairs({ "pwa-node", "pwa-chrome" }) do
        dap.adapters[adapter] = {
          type = "server",
          host = "localhost",
          port = "${port}",
          executable = {
            command = "js-debug-adapter",
            args = { "${port}" },
          },
        }
      end

      -- JS/TS configurations
      for _, lang in ipairs({ "javascript", "typescript", "javascriptreact", "typescriptreact" }) do
        dap.configurations[lang] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file (Node)",
            program = "${file}",
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach to Node process",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-chrome",
            request = "launch",
            name = "Launch Chrome (localhost:3000)",
            url = "http://localhost:3000",
            webRoot = "${workspaceFolder}",
          },
        }
      end

      -- C/C++ adapter (lldb-dap, bundled with Xcode)
      dap.adapters.lldb = {
        type = "executable",
        command = "/Applications/Xcode.app/Contents/Developer/usr/bin/lldb-dap",
        name = "lldb",
      }

      -- C/C++ configurations
      for _, lang in ipairs({ "c", "cpp" }) do
        dap.configurations[lang] = {
          {
            type = "lldb",
            request = "launch",
            name = "Launch build/main",
            program = "${workspaceFolder}/build/main",
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
          },
          {
            type = "lldb",
            request = "launch",
            name = "Launch executable (prompt)",
            program = function()
              return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            end,
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
          },
          {
            type = "lldb",
            request = "attach",
            name = "Attach to process",
            pid = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
        }
      end
    end,
  },
}
