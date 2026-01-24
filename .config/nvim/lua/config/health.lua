local M = {}

local health = vim.health

local function check_executable(name, required)
  if vim.fn.executable(name) == 1 then
    health.ok(name .. " found")
    return true
  elseif required then
    health.error(name .. " not found", { "Required for core functionality" })
    return false
  else
    health.warn(name .. " not found", { "Optional but recommended" })
    return false
  end
end

local function check_node()
  if vim.fn.executable("node") == 1 then
    local version = vim.fn.system("node --version"):gsub("%s+", "")
    health.ok("node " .. version)
    return true
  else
    health.error("node not found", { "Required for LSP servers (typescript, etc.)" })
    return false
  end
end

local function check_nvim_version()
  local version = vim.version()
  local required = { major = 0, minor = 10 }

  if version.major > required.major or
     (version.major == required.major and version.minor >= required.minor) then
    health.ok("Neovim " .. version.major .. "." .. version.minor .. "." .. version.patch)
    return true
  else
    health.error(
      "Neovim " .. version.major .. "." .. version.minor .. " (need >= 0.10)",
      { "Upgrade Neovim to 0.10+" }
    )
    return false
  end
end

function M.check()
  health.start("config")

  -- Neovim version
  health.start("Neovim Version")
  check_nvim_version()

  -- Required tools
  health.start("Required Tools")
  check_node()
  check_executable("npm", true)
  check_executable("rg", true) -- ripgrep for telescope

  -- Optional formatters
  health.start("Formatters (optional)")
  check_executable("biome", false)
  check_executable("stylua", false)
  check_executable("clang-format", false)

  -- Optional tools
  health.start("Other Tools (optional)")
  check_executable("fd", false)   -- faster telescope file search
  check_executable("tmux", false) -- tmux-navigator
  check_executable("git", false)  -- version control
end

return M
