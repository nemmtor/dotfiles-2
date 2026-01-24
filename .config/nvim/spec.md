# Neovim Config Improvement Spec

## Phase 1: Foundation

### 1.1 Baseline Measurement ✅

**Total startup: 134.21ms** (goal: <100ms, need to save ~34ms)

| Phase | Time |
|-------|------|
| LazyStart | 10.69ms |
| LazyDone | 113.77ms |
| UIEnter | 134.21ms |

**Top offenders (startup-loaded, could be lazy):**

| Plugin | Time | Potential Fix |
|--------|------|---------------|
| mason.nvim (+ blink, lspconfig) | 49.33ms | event=VeryLazy or LspAttach |
| Comment.nvim (+ treesitter chain) | 29.3ms | event=VeryLazy |
| telescope.nvim | 25.97ms | keys={...} |
| render-markdown.nvim | 10.18ms | ft=markdown |
| tokyonight.nvim | 8.57ms | keep (theme) |
| nvim-ufo | 8.77ms | event=BufReadPost |
| mini.nvim | 7.97ms | split modules |
| oil.nvim | 7.11ms | keys or cmd |
| outline.nvim | 6.85ms | keys=F2 |
| nvim-ts-autotag | 3.67ms | ft={html,tsx,...} |

**Already lazy (good):**
- conform.nvim: BufReadPre (1.29ms)
- nvim-early-retirement: VeryLazy (0.87ms)

**Estimated savable: ~80ms** (telescope, Comment chain, outline, oil, markdown, autotag)

### 1.2 Health Checks ✅

Add `:checkhealth` integration for dependency validation.

- [x] Create `lua/config/health.lua` module
- [x] Register health check with `vim.health`
- [x] Check required external tools:
  - [x] node/npm (LSP servers)
  - [x] ripgrep (telescope grep)
- [x] Check optional tools (warn if missing):
  - [x] biome, stylua, clang-format (formatters)
  - [x] fd (faster telescope file search)
  - [x] tmux (tmux-navigator)
- [x] Check Neovim version >= 0.10
- [ ] Test with `:checkhealth config`

---

## Phase 2: Code Organization

### 2.1 Modularize LSP Configs

Split language-specific LSP settings into separate files.

- [ ] Create `lua/config/lsp/` directory
- [ ] Create `lua/config/lsp/capabilities.lua` with `get_capabilities()`
- [ ] Create `lua/config/lsp/servers/` directory
- [ ] Extract lua_ls config to `servers/lua.lua`
- [ ] Extract tailwindcss config to `servers/tailwind.lua`
- [ ] Extract biome config to `servers/biome.lua`
- [ ] Extract clangd config to `servers/clangd.lua`
- [ ] Create `lua/config/lsp/init.lua` aggregating all configs
- [ ] Create `lua/config/lsp/on_attach.lua` for shared on_attach logic
- [ ] Update `plugins/lsp.lua` to import from new module
- [ ] Test all LSP servers attach correctly

### 2.2 Consolidate Scattered Keymaps

Move only scattered keymaps to central location. Plugin-internal keymaps stay in plugins.

**Scope**: Only move keymaps from:
- `config/keymaps.lua` (global keymaps)
- `config/telescope/keymaps.lua`
- LSP on_attach keymaps (currently in lsp.lua)

**NOT moving**: Plugin-internal keymaps (oil's Y, mini.move's Alt+hjkl, etc.)

- [ ] Create `lua/config/keymaps/` directory
- [ ] Create `lua/config/keymaps/init.lua` as loader
- [ ] Create `lua/config/keymaps/general.lua` (from current keymaps.lua)
  - [ ] Add which-key descriptions to each keymap
- [ ] Create `lua/config/keymaps/lsp.lua`
  - [ ] Export `M.on_attach(client, bufnr)` function
  - [ ] Add which-key descriptions to each keymap
- [ ] Create `lua/config/keymaps/telescope.lua`
  - [ ] Keep as regular keymaps (telescope uses `keys` for lazy-loading)
  - [ ] Add which-key descriptions to each keymap
- [ ] Update `lsp/on_attach.lua` to call `keymaps.lsp.on_attach()`
- [ ] Update `init.lua` to load new keymaps module
- [ ] Delete old `lua/config/keymaps.lua`
- [ ] Delete `lua/config/telescope/keymaps.lua`
- [ ] Verify all keymaps work

---

## Phase 3: Performance

### 3.1 Lazy-Loading Optimization

Target: under 100ms startup.

- [ ] Add `event = "VeryLazy"` to which-key.lua
- [ ] Add `event = "BufReadPost"` to treesitter.lua
- [ ] Add `event = "InsertEnter"` to completion.lua
- [ ] Add `ft = { "typescript", ... }` to typescript-tools.lua
- [ ] Add `ft` triggers to ts-autotag.lua
- [ ] Add `cmd` triggers to: undotree, zen-mode
- [ ] Convert outline.nvim to `keys = { "<F2>" }` trigger
- [ ] Lazy-load telescope extensions (fzf-native, live-grep-args)
- [ ] Audit mini.nvim - defer non-essential modules
- [ ] Re-run `:Lazy profile` and compare to baseline
- [ ] Document improvement in REPO_ANALYSIS.MD

---

## Phase 4: Robustness

### 4.1 TypeScript Tools Fallback

Graceful degradation when TS server unavailable.

- [ ] Check node/npm in typescript-tools.lua config
- [ ] Show notification if node missing, skip TS setup
- [ ] Add timeout handling for slow server starts
- [ ] Add `:TSToolsStatus` command showing server state
- [ ] Handle tsserver crash gracefully (auto-restart or notify)

---

## Phase 5: Documentation

### 5.1 Keymap Documentation Generator

Auto-generate KEYMAPS.md from code.

**Prerequisite**: Phase 2.2 complete (keymaps have which-key descriptions)

- [ ] Create `lua/config/docs/keymaps.lua` generator
- [ ] Parse keymaps from `config/keymaps/` modules
- [ ] Parse keymaps from plugin specs (lazy.nvim `keys` field)
- [ ] Generate markdown with columns: key, mode, action, source
- [ ] Create `:GenerateKeymapDocs` command
- [ ] Output to `KEYMAPS.md`
- [ ] Run generator and commit initial KEYMAPS.md

---

## Dependency Graph

```
1.1 Baseline ─────┐
                  ├──▶ 3.1 Lazy-Loading ──▶ Compare to baseline
1.2 Health ───────┘
                         │
                         ▼
2.1 LSP Modularize ◀─────┤
        │                │
        ▼                │
2.2 Keymaps ─────────────┴──▶ 5.1 Doc Generation
        │
        ▼
4.1 TS Fallback (can use patterns from 2.1)
```

---

## Execution Order

| Order | Task | Depends On | Risk |
|-------|------|------------|------|
| 1 | 1.1 Baseline | - | None |
| 2 | 1.2 Health Checks | - | Low |
| 3 | 2.1 LSP Modularize | - | Medium |
| 4 | 2.2 Keymaps | 2.1 (shares on_attach) | Medium |
| 5 | 3.1 Lazy-Loading | 1.1, 2.2 | Low |
| 6 | 4.1 TS Fallback | 2.1 | Low |
| 7 | 5.1 Doc Generation | 2.2 | Low |

---

## Resolved Questions

- **Keymap organization**: By feature (lsp.lua, telescope.lua, general.lua)
- **LSP keymaps**: Only bind on LspAttach via exported on_attach function
- **Startup time goal**: Under 100ms
- **Telescope extensions**: Lazy-load on first Telescope use
- **Health check optional tools**: Warn (yellow)
- **Keymap + lazy conflict**: Hybrid - plugin-trigger keymaps stay in plugins, always-available go central
- **Extraction scope**: Only scattered keymaps (keymaps.lua, telescope/keymaps.lua, LSP on_attach)
