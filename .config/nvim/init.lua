local function set_options()
  vim.opt.termguicolors = true -- full color support

  vim.opt.number = true -- line number
  vim.opt.relativenumber = true -- relative line numbers
  vim.opt.cursorline = true -- highlight current line
  vim.opt.wrap = false -- do not wrap lines by default
  vim.opt.scrolloff = 10 -- keep 10 lines above/below cursor
  vim.opt.sidescrolloff = 10 -- keep 10 lines to left/right of cursor

  vim.opt.tabstop = 2 -- tab width
  vim.opt.shiftwidth = 2 -- indent width
  vim.opt.softtabstop = 2 -- soft tab stop not tabs on tab/backspacke
  vim.opt.expandtab = true -- use spaces instead of tabs
  vim.opt.smartindent = true -- smart auto-indent
  vim.opt.autoindent = true -- copy indent from current line
  vim.opt.breakindent = true -- wrapped lines keep indent

  vim.opt.ignorecase = true -- case insensitive search
  vim.opt.smartcase = true -- case sensitive if uppercase in string
  vim.opt.hlsearch = true -- highlight search matches
  vim.opt.incsearch = true -- show matches as you type

  vim.opt.signcolumn = "yes" -- always show a sign column
  vim.opt.colorcolumn = "80" -- show a column at 80 position chars
  vim.opt.showmatch = true -- highlights matching brackets
  vim.opt.cmdheight = 1 -- single line command line
  vim.opt.completeopt = "menuone,noinsert,noselect" -- completion options
  vim.opt.showmode = false -- do not show the mode, instead have it in statusline
  vim.opt.pumheight = 10 -- popup menu height
  vim.opt.pumblend = 10 -- popup menu transparency
  vim.opt.winblend = 0 -- floating window transparency
  vim.opt.conceallevel = 0 -- do not hide markup
  vim.opt.concealcursor = "" -- do not hide cursorline in markup
  vim.opt.synmaxcol = 300 -- syntax highlight limit
  vim.opt.fillchars = { eob = " " } -- hide "~" on empty lines

  vim.opt.backup = false -- do not create a backup file
  vim.opt.writebackup = false -- do not write to a backup file
  vim.opt.swapfile = false -- do not create a swapfile
  vim.opt.undofile = true -- do create an undo file (default undodir: stdpath("state")/undo)
  vim.opt.updatetime = 300 -- faster completion
  vim.opt.timeoutlen = 500 -- timeout duration
  vim.opt.ttimeoutlen = 0 -- key code timeout
  vim.opt.autoread = true -- auto-reload changes if outside of neovim
  vim.opt.autowrite = false -- do not auto-save

  vim.opt.hidden = true -- allow hidden buffers
  vim.opt.errorbells = false -- no error sounds
  vim.opt.backspace = "indent,eol,start" -- better backspace behaviour
  vim.opt.autochdir = false -- do not autochange directories
  vim.opt.iskeyword:append("-") -- include - in words
  vim.opt.path:append("**") -- include subdirs in search
  vim.opt.selection = "inclusive" -- include last char in selection
  vim.opt.mouse = "a" -- enable mouse support
  vim.opt.clipboard:append("unnamedplus") -- use system clipboard
  vim.opt.modifiable = true -- allow buffer modifications

  vim.opt.guicursor =
    "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175" -- cursor blinking and settings; bar cursor in insert

  -- Folding: requires treesitter available at runtime; safe fallback if not
  vim.opt.foldmethod = "expr" -- use expression for folding
  vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- use treesitter for folding
  vim.opt.foldlevel = 99 -- start with all folds open
  vim.opt.foldlevelstart = 99 -- reset foldlevel per new buffer
  vim.opt.foldcolumn = "1" -- show fold gutter column

  vim.opt.splitbelow = true -- horizontal splits go below
  vim.opt.splitright = true -- vertical splits go right

  vim.opt.wildmenu = true -- tab completion
  vim.opt.wildmode = "longest:full,full" -- complete longest common match, full completion list, cycle through with Tab
  vim.opt.diffopt:append("linematch:60") -- improve diff display
  vim.opt.redrawtime = 10000 -- increase neovim redraw tolerance
  vim.opt.maxmempattern = 20000 -- increase max memory
end

set_options()

-- no remote-plugin providers used; disable to silence :checkhealth and skip detection
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python3_provider = 0

local function set_keymaps()
  vim.g.mapleader = " " -- space for leader
  vim.g.maplocalleader = " " -- space for localleader

  -- better movement in wrapped text
  vim.keymap.set("n", "j", function()
    return vim.v.count == 0 and "gj" or "j"
  end, { expr = true, silent = true, desc = "Down (wrap-aware)" })
  vim.keymap.set("n", "k", function()
    return vim.v.count == 0 and "gk" or "k"
  end, { expr = true, silent = true, desc = "Up (wrap-aware)" })

  vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

  vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
  vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })

  vim.keymap.set("n", "<leader>sv", ":vsplit<CR>", { desc = "Split window vertically" })
  vim.keymap.set("n", "<leader>sh", ":split<CR>", { desc = "Split window horizontally" })
  vim.keymap.set("n", "<C-k>", ":resize +2<CR>", { desc = "Increase window height" })
  vim.keymap.set("n", "<C-j>", ":resize -2<CR>", { desc = "Decrease window height" })
  vim.keymap.set("n", "<C-h>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
  vim.keymap.set("n", "<C-l>", ":vertical resize +2<CR>", { desc = "Increase window width" })

  -- line/selection moving handled by mini.move (<M-h/j/k/l>)

  vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
  vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

  vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })

  vim.keymap.set("n", "<leader>pa", function() -- show file path
    local path = vim.fn.expand("%:p")
    vim.fn.setreg("+", path)
    print("file:", path)
  end, { desc = "Copy full file path" })

  vim.keymap.set("n", "<leader>td", function()
    vim.diagnostic.enable(not vim.diagnostic.is_enabled())
  end, { desc = "Toggle diagnostics" })

  vim.keymap.set("n", "q:", function() end, { desc = "Disable q: typo" })
end
set_keymaps()

local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })
local function set_autocmds()
  -- Format on save (ONLY real file buffers, ONLY when efm is attached;
  -- efm attaches only to its configured filetypes, so no pattern list needed)
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = augroup,
    callback = function(args)
      -- avoid formatting non-file buffers (helps prevent weird write prompts)
      if vim.bo[args.buf].buftype ~= "" then
        return
      end
      if not vim.bo[args.buf].modifiable then
        return
      end
      if vim.api.nvim_buf_get_name(args.buf) == "" then
        return
      end

      local has_efm = false
      for _, c in ipairs(vim.lsp.get_clients({ bufnr = args.buf })) do
        if c.name == "efm" then
          has_efm = true
          break
        end
      end
      if not has_efm then
        return
      end

      pcall(vim.lsp.buf.format, {
        bufnr = args.buf,
        timeout_ms = 2000,
        filter = function(c)
          return c.name == "efm"
        end,
      })
    end,
  })

  -- highlight yanked text
  vim.api.nvim_create_autocmd("TextYankPost", {
    group = augroup,
    callback = function()
      vim.hl.hl_op()
    end,
  })

  -- return to last cursor position
  vim.api.nvim_create_autocmd("BufReadPost", {
    group = augroup,
    desc = "Restore last cursor position",
    callback = function()
      if vim.o.diff then -- except in diff mode
        return
      end

      local last_pos = vim.api.nvim_buf_get_mark(0, '"') -- {line, col}
      local last_line = vim.api.nvim_buf_line_count(0)

      local row = last_pos[1]
      if row < 1 or row > last_line then
        return
      end

      pcall(vim.api.nvim_win_set_cursor, 0, last_pos)
    end,
  })

  -- wrap, linebreak and spellcheck on markdown and text files
  vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    pattern = { "markdown", "text", "gitcommit" },
    callback = function()
      vim.opt_local.wrap = true
      vim.opt_local.linebreak = true
      vim.opt_local.spell = true
    end,
  })
end

set_autocmds()

-- vim.pack has no `build` hook; run :TSUpdate when treesitter is installed/updated
vim.api.nvim_create_autocmd("PackChanged", {
  group = augroup,
  callback = function(ev)
    if ev.data.spec.name == "nvim-treesitter" and (ev.data.kind == "install" or ev.data.kind == "update") then
      vim.schedule(function()
        vim.cmd.TSUpdate()
      end)
    end
  end,
})

vim.pack.add({
  "https://github.com/folke/tokyonight.nvim",
  "https://github.com/stevearc/oil.nvim",
  "https://www.github.com/echasnovski/mini.nvim",
  "https://github.com/folke/snacks.nvim",
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
    version = "main",
  },
  -- Language Server Protocols
  "https://www.github.com/neovim/nvim-lspconfig",
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/creativenull/efmls-configs-nvim",
  "https://github.com/moyiz/blink-emoji.nvim",
  {
    src = "https://github.com/saghen/blink.cmp",
    version = vim.version.range("1.*"),
  },
  "https://github.com/L3MON4D3/LuaSnip",
  "https://github.com/marilari88/twoslash-queries.nvim",
  "https://github.com/hedyhli/outline.nvim",
  "https://github.com/mbbill/undotree",
  "https://github.com/folke/which-key.nvim",
  "https://github.com/folke/trouble.nvim",
  "https://github.com/windwp/nvim-ts-autotag",
  "https://github.com/nvim-treesitter/nvim-treesitter-context",
  "https://github.com/MeanderingProgrammer/render-markdown.nvim",
  "https://github.com/esmuellert/codediff.nvim",
})

-- ============================================================================
-- PLUGIN CONFIGS
-- ============================================================================
vim.cmd.colorscheme("tokyonight-storm")
local setup_treesitter = function()
  local treesitter = require("nvim-treesitter")
  treesitter.setup({})
  local ensure_installed = {
    "vim",
    "vimdoc",
    -- "rust",
    -- "c",
    -- "cpp",
    -- "go",
    "html",
    "css",
    "javascript",
    "json",
    "lua",
    "markdown",
    "markdown_inline", -- required by render-markdown
    -- "python",
    "typescript",
    -- "vue",
    -- "svelte",
    "bash",
  }

  local config = require("nvim-treesitter.config")

  local already_installed = config.get_installed()
  local parsers_to_install = {}

  for _, parser in ipairs(ensure_installed) do
    if not vim.tbl_contains(already_installed, parser) then
      table.insert(parsers_to_install, parser)
    end
  end

  if #parsers_to_install > 0 then
    treesitter.install(parsers_to_install)
  end

  local group = vim.api.nvim_create_augroup("TreeSitterConfig", { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    callback = function(args)
      if vim.list_contains(config.get_installed(), vim.treesitter.language.get_lang(args.match)) then
        vim.treesitter.start(args.buf)
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
    end,
  })
end

setup_treesitter()

local setup_oil = function()
  local oil = require("oil")
  oil.setup({
    default_file_explorer = true,
    delete_to_trash = true,
    skip_confirm_for_simple_edits = true,
    columns = { "icon" },
    view_options = {
      show_hidden = true,
      natural_order = true,
      is_always_hidden = function(name, _)
        return name == ".git" or name == ".DS_Store"
      end,
    },
    keymaps = {
      ["Y"] = {
        desc = "Copy filepath to system clipboard",
        mode = "n",
        callback = function()
          local entry = oil.get_cursor_entry()
          local dir = oil.get_current_dir()

          if not entry or not dir then
            return
          end

          local relpath = vim.fn.fnamemodify(dir, ":.")

          vim.fn.setreg("+", relpath .. entry.name)
        end,
      },
      ["q"] = {
        desc = "Close Oil",
        mode = "n",
        callback = function()
          oil.close()
        end,
      },
    },
    win_options = {
      wrap = true,
    },
    float = {
      padding = 5,
    },
  })
end

setup_oil()

local setup_snacks = function()
  local snacks = require("snacks")
  snacks.setup({
    bigfile = { enabled = true },
    image = { enabled = true },
    input = { enabled = true },
    notifier = { enabled = true },
    picker = { enabled = true, ui_select = true },
  })
end
setup_snacks()
vim.keymap.set("n", "<leader>sf", function()
  require("snacks").picker.files()
end, { desc = "Search Files" })
vim.keymap.set("n", "<leader>sg", function()
  require("snacks").picker.grep()
end, { desc = "Search Grep" })
vim.keymap.set("n", "<leader>?", function()
  require("snacks").picker.recent({ filter = { cwd = true } })
end, { desc = "Search Recent Files" })
vim.keymap.set("n", "<leader>th", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Toggle inlay hints" })
vim.keymap.set("n", "<space>lr", vim.lsp.buf.rename, { desc = "Rename" })
vim.keymap.set("n", "<space>la", vim.lsp.buf.code_action, { desc = "Code Action" })

vim.keymap.set("n", "<F1>", function()
  require("oil").toggle_float()
end, { desc = "Toggle FileTree" })

require("mini.ai").setup({})
require("mini.comment").setup({})
require("mini.move").setup({})
require("mini.surround").setup({})
require("mini.cursorword").setup({})
require("mini.indentscope").setup({})
require("mini.pairs").setup({})
require("mini.trailspace").setup({})

require("mini.bufremove").setup({})
require("mini.icons").setup({})
require("mini.statusline").setup({ use_icons = true })

require("mini.diff").setup({
  view = {
    style = "sign",
    signs = { add = "▎", change = "▎", delete = "▎" },
  },
})

require("mini.git").setup({})
local hipatterns = require("mini.hipatterns")
hipatterns.setup({
  highlighters = {
    todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHiPatternsTodo" },
    fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHiPatternsFixme" },
    hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHiPatternsHack" },
    note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHiPatternsNote" },
  },

  hex_color = hipatterns.gen_highlighter.hex_color(),
})

vim.keymap.set("n", "<leader>hb", function()
  require("mini.git").show_at_cursor()
end, { desc = "Git blame/show" })

require("codediff").setup({})
vim.keymap.set("n", "<leader>lg", "<cmd>CodeDiff<CR>", { desc = "CodeDiff git status" })

require("which-key").setup({})

require("outline").setup({
  outline_window = {
    position = "left",
    width = 40,
  },
})
vim.keymap.set("n", "<F2>", function()
  require("outline").toggle()
end, { desc = "Toggle outline" })

vim.keymap.set("n", "<F3>", function()
  vim.cmd.UndotreeToggle()
  vim.cmd.UndotreeFocus()
end, { desc = "Toggle undo tree" })

require("nvim-ts-autotag").setup({
  opts = {
    enable_close = true,
    enable_rename = true,
    enable_close_on_slash = false,
  },
  per_filetype = {
    ["html"] = { enable_close = false },
  },
})

require("treesitter-context").setup({})

require("render-markdown").setup({
  latex = { enabled = false }, -- no latex tools installed
})

require("twoslash-queries").setup({
  is_enabled = true,
  multi_line = true,
})
vim.keymap.set("n", "ti", "<cmd>TwoslashQueriesInspect<CR>", { desc = "[T]ypescript [I]nspect" })

require("mason").setup({})

do -- ensure mason tools installed
  local registry = require("mason-registry")
  local tools = {
    "efm",
    "lua-language-server",
    "bash-language-server",
    "typescript-language-server",
    "stylua",
    "prettierd",
    "eslint-lsp",
    "fixjson",
    "shellcheck",
    "shfmt",
  }
  for _, tool in ipairs(tools) do
    local ok, pkg = pcall(registry.get_package, tool)
    if ok and not pkg:is_installed() then
      vim.notify("mason: installing " .. tool)
      pkg:install()
    end
  end
end

-- ============================================================================
-- LSP, Linting, Formatting & Completion
-- ============================================================================
local diagnostic_signs = {
  Error = "\u{f057} ",
  Warn = "\u{f071} ",
  Hint = "\u{ea61}",
  Info = "\u{f05a}",
}

vim.diagnostic.config({
  virtual_text = { prefix = "●", spacing = 4 },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = diagnostic_signs.Error,
      [vim.diagnostic.severity.WARN] = diagnostic_signs.Warn,
      [vim.diagnostic.severity.INFO] = diagnostic_signs.Info,
      [vim.diagnostic.severity.HINT] = diagnostic_signs.Hint,
    },
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  jump = {
    on_jump = function(_, bufnr)
      vim.diagnostic.open_float(bufnr, { scope = "cursor", focus = false })
    end,
  },
  float = {
    source = true,
    header = "",
    prefix = "",
    focusable = false,
    style = "minimal",
  },
})

vim.o.winborder = "rounded" -- default border for all floating windows

local function lsp_on_attach(ev)
  local client = vim.lsp.get_client_by_id(ev.data.client_id)
  if not client then
    return
  end

  local bufnr = ev.buf
  local opts = { noremap = true, silent = true, buffer = bufnr }

  if client.name == "ts_ls" then
    require("twoslash-queries").attach(client, bufnr)
  end

  vim.keymap.set("n", "<leader>]d", function()
    vim.diagnostic.jump({ count = 1 })
  end, opts)

  vim.keymap.set("n", "<leader>[d", function()
    vim.diagnostic.jump({ count = -1 })
  end, opts)

  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "gr", function()
    require("snacks").picker.lsp_references()
  end, opts)
  vim.keymap.set("n", "gd", function()
    require("snacks").picker.lsp_definitions()
  end, opts)
  vim.keymap.set("n", "gi", function()
    require("snacks").picker.lsp_implementations()
  end, opts)
  vim.keymap.set("n", "gt", function()
    require("snacks").picker.lsp_type_definitions()
  end, opts)

  local format_with_efm = function()
    vim.lsp.buf.format({
      bufnr = bufnr,
      filter = function(c)
        return c.name == "efm"
      end,
    })
  end

  if client.name == "ts_ls" then
    -- code-action organizeImports is forced non-destructive (never removes
    -- unused imports); the executeCommand path defaults to mode "All"
    vim.keymap.set("n", "<leader>oi", function()
      client:exec_cmd({
        title = "Organize Imports",
        command = "_typescript.organizeImports",
        arguments = { vim.api.nvim_buf_get_name(bufnr) },
      }, { bufnr = bufnr }, function()
        format_with_efm()
      end)
    end, opts)
  elseif client:supports_method("textDocument/codeAction", bufnr) then
    vim.keymap.set("n", "<leader>oi", function()
      vim.lsp.buf.code_action({
        context = { only = { "source.organizeImports" }, diagnostics = {} },
        apply = true,
        bufnr = bufnr,
      })
      vim.defer_fn(format_with_efm, 50)
    end, opts)
  end
end

vim.api.nvim_create_autocmd("LspAttach", { group = augroup, callback = lsp_on_attach })

require("trouble").setup({})

require("blink.cmp").setup({
  keymap = {
    preset = "enter",
  },
  appearance = { nerd_font_variant = "mono" },
  enabled = function()
    return vim.bo.buftype ~= "nofile" and vim.bo.buftype ~= "prompt"
  end,
  sources = {
    default = { "lsp", "emoji" },
    providers = {
      emoji = {
        module = "blink-emoji",
        name = "Emoji",
        score_offset = 93,
        opts = { insert = true },
      },
    },
  },
  signature = { enabled = true },
  cmdline = {
    enabled = true,
    keymap = { preset = "enter" },
  },
  completion = {
    menu = {
      auto_show = false,
      border = "single",
    },
    accept = {
      auto_brackets = {
        enabled = false,
      },
    },
  },
  snippets = {
    expand = function(snippet)
      require("luasnip").lsp_expand(snippet)
    end,
  },
  fuzzy = {
    implementation = "prefer_rust",
    prebuilt_binaries = { download = true },
  },
})

vim.lsp.config["*"] = {
  capabilities = require("blink.cmp").get_lsp_capabilities(),
}

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      hint = { enable = true },
      telemetry = { enable = false },
    },
  },
})
-- vim.lsp.config("pyright", {})
vim.lsp.config("bashls", {})
local ts_inlay_hints = {
  includeInlayParameterNameHints = "all",
  includeInlayFunctionParameterTypeHints = true,
  includeInlayVariableTypeHints = true,
  includeInlayPropertyDeclarationTypeHints = true,
  includeInlayFunctionLikeReturnTypeHints = true,
  includeInlayEnumMemberValueHints = true,
}
vim.lsp.config("ts_ls", {
  settings = {
    typescript = { inlayHints = ts_inlay_hints },
    javascript = { inlayHints = ts_inlay_hints },
  },
})
-- vim.lsp.config("gopls", {})
-- vim.lsp.config("clangd", {})

-- vim.g.rustaceanvim = {
-- 	server = {
-- 		capabilities = require("blink.cmp").get_lsp_capabilities(),
-- 	},
-- }

do
  local stylua = require("efmls-configs.formatters.stylua")
  local fish_indent = require("efmls-configs.formatters.fish_indent")

  -- local flake8 = require("efmls-configs.linters.flake8")
  -- local black = require("efmls-configs.formatters.black")

  local prettier_d = require("efmls-configs.formatters.prettier_d")

  local fixjson = require("efmls-configs.formatters.fixjson")

  local shellcheck = require("efmls-configs.linters.shellcheck")
  local shfmt = require("efmls-configs.formatters.shfmt")

  -- local cpplint = require("efmls-configs.linters.cpplint")
  -- local clangfmt = require("efmls-configs.formatters.clang_format")

  -- local go_revive = require("efmls-configs.linters.go_revive")
  -- local gofumpt = require("efmls-configs.formatters.gofumpt")

  vim.lsp.config("efm", {
    filetypes = {
      -- "c",
      -- "cpp",
      "css",
      -- "go",
      "fish",
      "html",
      "javascript",
      "javascriptreact",
      "json",
      "jsonc",
      "lua",
      "markdown",
      -- "python",
      "sh",
      "typescript",
      "typescriptreact",
      -- "vue",
      -- "svelte",
    },
    init_options = { documentFormatting = true },
    settings = {
      languages = {
        -- c = { clangfmt, cpplint },
        -- go = { gofumpt, go_revive },
        -- cpp = { clangfmt, cpplint },
        css = { prettier_d },
        fish = { fish_indent },
        html = { prettier_d },
        javascript = { prettier_d },
        javascriptreact = { prettier_d },
        json = { fixjson },
        jsonc = { fixjson },
        lua = { stylua },
        markdown = { prettier_d },
        -- python = { flake8, black },
        sh = { shellcheck, shfmt },
        typescript = { prettier_d },
        typescriptreact = { prettier_d },
        -- vue = { eslint_d, prettier_d },
        -- svelte = { eslint_d, prettier_d },
      },
    },
  })
end

vim.lsp.enable({
  "lua_ls",
  -- "pyright",
  "bashls",
  "ts_ls",
  "eslint",
  -- "gopls",
  -- "clangd",
  "efm",
})
