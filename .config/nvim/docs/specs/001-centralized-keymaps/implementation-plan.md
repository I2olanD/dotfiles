# Implementation Plan

## Validation Checklist

- [x] All specification file paths are correct and exist
- [x] Context priming section is complete
- [x] All implementation phases are defined
- [ ] Each phase follows TDD: Prime → Test → Implement → Validate
- [x] Dependencies between phases are clear (no circular dependencies)
- [x] Parallel work is properly tagged with `[parallel: true]`
- [x] Activity hints provided for specialist selection `[activity: type]`
- [ ] Every phase references relevant SDD sections (N/A - no SDD)
- [ ] Every test references PRD acceptance criteria (N/A - no PRD)
- [x] Integration & E2E tests defined in final phase
- [x] Project commands match actual project setup
- [x] A developer could follow this plan independently

---

## Context Priming

*GATE: You MUST fully read all files mentioned in this section before starting any implementation.*

**Source Files to Extract Keymaps From:**

| File | Keymap Type | Lines |
|------|-------------|-------|
| `lua/mappings.lua` | Core vim keymaps | 1-11 |
| `lua/plugins/lsp.lua` | LSP buffer-local keymaps (on_attach) | 45-61 |
| `lua/plugins/fzf.lua` | Lazy `keys` table | 5-10 |
| `lua/plugins/oil.lua` | Lazy `keys` table + opts.keymaps | 6-14 |
| `lua/plugins/trouble.lua` | Lazy `keys` table | 5-7 |
| `lua/plugins/formatter.lua` | vim.keymap.set in config | 39-45 |
| `lua/plugins/bufferline.lua` | Lazy `keys` table | 11-18 |
| `lua/plugins/windows.lua` | Lazy `keys` table | 19-21 |
| `lua/plugins/visual-multi.lua` | Lazy `keys` table | 3-7 |
| `lua/plugins/whichkeys.lua` | Lazy `keys` table | 9-17 |
| `lua/plugins/cmp.lua` | cmp.mapping in config | 42-66 |

**Key Design Decisions:**

1. Create single `lua/keymaps.lua` file for all keymaps
2. Group keymaps by category (vim core, navigation, LSP, plugins)
3. Keep plugin-internal keymaps (oil `q`/`Esc`, cmp insert-mode) in plugin files
4. Remove `keys` tables from plugin specs (keeps lazy loading via `cmd`/`event`)
5. LSP keymaps stay buffer-local but centralized in keymaps file

**Implementation Context:**

- Commands to run: `nvim --headless -c "lua print('ok')" -c "qa"` (verify config loads)
- Patterns to follow: Use `vim.keymap.set()` with descriptive `desc` fields
- Leader key: Space (defined in `lua/options.lua`)

---

## Implementation Phases

- [x] T1 Phase 1: Create Centralized Keymaps File

    - [ ] T1.1 Prime Context
        - [ ] T1.1.1 Read all source files listed above `[ref: Context Priming section]`
        - [ ] T1.1.2 Identify which keymaps can be centralized vs must stay local

    - [ ] T1.2 Implement: Create `lua/keymaps.lua`
        - [ ] T1.2.1 Create file with header and M table pattern `[activity: file-creation]`
        - [ ] T1.2.2 Add Vim Core section (escape, line movement, paste) `[ref: lua/mappings.lua; lines: 1-11]`
        - [ ] T1.2.3 Add File Navigation section (FZF keymaps) `[ref: lua/plugins/fzf.lua; lines: 5-10]`
        - [ ] T1.2.4 Add File Explorer section (Oil keymaps) `[ref: lua/plugins/oil.lua; lines: 11-14]`
        - [ ] T1.2.5 Add Buffer Management section (Bufferline keymaps) `[ref: lua/plugins/bufferline.lua; lines: 11-18]`
        - [ ] T1.2.6 Add Window Management section (Windows keymaps) `[ref: lua/plugins/windows.lua; lines: 19-21]`
        - [ ] T1.2.7 Add Diagnostics section (Trouble keymaps) `[ref: lua/plugins/trouble.lua; lines: 5-7]`
        - [ ] T1.2.8 Add Formatting section (Conform keymaps) `[ref: lua/plugins/formatter.lua; lines: 39-45]`
        - [ ] T1.2.9 Add Multi-cursor section (Visual-multi keymaps) `[ref: lua/plugins/visual-multi.lua; lines: 3-7]`
        - [ ] T1.2.10 Add Help section (Which-key keymaps) `[ref: lua/plugins/whichkeys.lua; lines: 9-17]`
        - [ ] T1.2.11 Export LSP on_attach function for buffer-local keymaps `[ref: lua/plugins/lsp.lua; lines: 45-61]`

    - [ ] T1.3 Validate
        - [ ] T1.3.1 Verify file syntax with luacheck `[activity: lint-code]`
        - [ ] T1.3.2 Verify all keymaps have `desc` field `[activity: review-code]`

- [x] T2 Phase 2: Update Plugin Files `[parallel: true]`

    - [ ] T2.1 Update `lua/plugins/fzf.lua` `[parallel: true]` `[component: fzf]`
        - [ ] T2.1.1 Remove `keys` table
        - [ ] T2.1.2 Ensure lazy loading via `cmd = "FzfLua"` remains

    - [ ] T2.2 Update `lua/plugins/oil.lua` `[parallel: true]` `[component: oil]`
        - [ ] T2.2.1 Remove `keys` table (global keymaps)
        - [ ] T2.2.2 Keep `opts.keymaps` (buffer-local `q`/`Esc`)

    - [ ] T2.3 Update `lua/plugins/trouble.lua` `[parallel: true]` `[component: trouble]`
        - [ ] T2.3.1 Remove `keys` table
        - [ ] T2.3.2 Ensure lazy loading via `cmd = "Trouble"` remains

    - [ ] T2.4 Update `lua/plugins/formatter.lua` `[parallel: true]` `[component: formatter]`
        - [ ] T2.4.1 Remove `vim.keymap.set` from config function
        - [ ] T2.4.2 Lazy loading via `event` remains

    - [ ] T2.5 Update `lua/plugins/bufferline.lua` `[parallel: true]` `[component: bufferline]`
        - [ ] T2.5.1 Remove `keys` table

    - [ ] T2.6 Update `lua/plugins/windows.lua` `[parallel: true]` `[component: windows]`
        - [ ] T2.6.1 Remove `keys` table

    - [ ] T2.7 Update `lua/plugins/visual-multi.lua` `[parallel: true]` `[component: visual-multi]`
        - [ ] T2.7.1 Remove `keys` table

    - [ ] T2.8 Update `lua/plugins/whichkeys.lua` `[parallel: true]` `[component: whichkeys]`
        - [ ] T2.8.1 Remove `keys` table

    - [ ] T2.9 Update `lua/plugins/lsp.lua` `[parallel: true]` `[component: lsp]`
        - [ ] T2.9.1 Remove local `on_attach` function
        - [ ] T2.9.2 Import `on_attach` from keymaps module
        - [ ] T2.9.3 Fix duplicate `<leader>gd` bug (declaration vs definition)

- [x] T3 Phase 3: Update Init and Remove Old Files

    - [ ] T3.1 Implement
        - [ ] T3.1.1 Require keymaps module in appropriate location `[activity: config-update]`
        - [ ] T3.1.2 Delete `lua/mappings.lua` (replaced by keymaps.lua)

    - [ ] T3.2 Validate
        - [ ] T3.2.1 Run luacheck on all modified files `[activity: lint-code]`

- [x] T4 Integration & End-to-End Validation

    - [ ] T4.1 Start Neovim with new config: `nvim --headless -c "lua print('ok')" -c "qa"`
    - [ ] T4.2 Verify all keymaps registered: `nvim -c "verbose map <leader>"`
    - [ ] T4.3 Manual testing checklist:
        - [ ] T4.3.1 `<Esc>` clears search highlight
        - [ ] T4.3.2 `<leader>ff` opens FZF file finder
        - [ ] T4.3.3 `<leader>e` opens Oil
        - [ ] T4.3.4 `<leader>tt` opens Trouble
        - [ ] T4.3.5 `<leader>mp` formats file
        - [ ] T4.3.6 Arrow keys navigate buffers
        - [ ] T4.3.7 `<C-m>` maximizes window
        - [ ] T4.3.8 LSP keymaps work in buffer with LSP
        - [ ] T4.3.9 Completion keymaps work in insert mode
    - [ ] T4.4 Verify which-key shows all keymaps with `<leader>?`

---

## File Structure After Implementation

```
lua/
├── options.lua      (unchanged - leader key stays here)
├── keymaps.lua      (NEW - all keymaps consolidated)
├── autocmd.lua      (unchanged)
└── plugins/
    ├── lsp.lua      (uses keymaps.on_attach)
    ├── fzf.lua      (no keys table)
    ├── oil.lua      (keeps buffer-local keymaps only)
    ├── cmp.lua      (keeps insert-mode keymaps - tightly coupled)
    └── ...          (other plugins - no keys tables)
```

## Keymaps NOT Centralized (by design)

| Plugin | Keymaps | Reason |
|--------|---------|--------|
| oil.nvim | `q`, `<Esc>` | Buffer-local to Oil buffers only |
| nvim-cmp | `<C-j>`, `<C-k>`, etc. | Insert-mode completion, tightly coupled to cmp API |

## Notes

- **Bug fix included**: `lua/plugins/lsp.lua` has duplicate `<leader>gd` mapping (declaration then definition). Will consolidate to definition with separate `<leader>gD` for declaration.
- **Lazy loading impact**: Removing `keys` tables means plugins load via `cmd`/`event` instead. FZF loads on `:FzfLua`, Trouble on `:Trouble`, etc. This is the intended behavior.
