# Dotfiles

Personal macOS development environment managed with [yadm](https://yadm.io/).

## Quick Start

```bash
# Install yadm
brew install yadm

# Clone dotfiles
yadm clone <repo-url>

# Run bootstrap
yadm bootstrap
```

The bootstrap script will:

1. Install all Homebrew packages from `homebrew/Brewfile`
2. Set up tmux with TPM plugins
3. Configure WezTerm terminfo

---

## Structure

```
~/.config/
├── homebrew/           # Brewfile for package management
├── mise/               # Runtime version management (node, go, bun)
├── nvim/               # Neovim configuration
├── oh-my-posh/         # Shell prompt themes
├── opencode/           # OpenCode AI agent configuration
├── tmux/               # Tmux configuration
├── wezterm/            # Terminal emulator config
└── yadm/               # Dotfile manager bootstrap
```

---

## Terminal Stack

### WezTerm

**File:** `wezterm/wezterm.lua`

GPU-accelerated terminal with automatic theme switching.

| Setting  | Value                                    |
| -------- | ---------------------------------------- |
| Font     | Hack Nerd Font @ 13pt                    |
| Theme    | Catppuccin (Mocha/Latte based on system) |
| Renderer | WebGpu                                   |

### Tmux

**File:** `tmux/tmux.conf`

Terminal multiplexer with vim-style navigation.

**Plugins:**

- `vim-tmux-navigator` - Seamless vim/tmux pane navigation
- `tmux-dotbar` - Minimal status bar (Catppuccin colors)

**Key Bindings:**
| Key | Action |
|-----|--------|
| `\|` | Split horizontal |
| `-` | Split vertical |
| `c` | New window (preserves path) |
| `v` | Begin selection (copy mode) |
| `y` | Yank selection |

### Oh My Posh

**Files:** `oh-my-posh/catppuccin.json`, `oh-my-posh/tokyo.json`

Minimal prompt showing: username, path (agnoster style), git branch.

---

## Neovim

**Directory:** `nvim/`

Lazy.nvim-based configuration with Catppuccin Mocha theme.

### Key Features

- Space as leader key
- Relative line numbers
- System clipboard integration
- 2-space indentation
- No swap/backup files

### Plugins

| Plugin            | Purpose                                                   |
| ----------------- | --------------------------------------------------------- |
| **LSP**           | Mason + nvim-lspconfig (TypeScript, Lua, Go, Svelte, Vue) |
| **Completion**    | nvim-cmp with LSP source                                  |
| **Fuzzy Find**    | fzf-lua                                                   |
| **File Explorer** | Oil.nvim + Neo-tree                                       |
| **Formatting**    | Conform (prettier, gofumpt, stylua)                       |
| **Linting**       | nvim-lint (jsonlint, luacheck, htmlhint)                  |
| **Treesitter**    | Syntax highlighting and text objects                      |
| **UI**            | Bufferline, Lualine, Noice, Which-key                     |
| **Editing**       | Autopairs, Surround, vim-visual-multi                     |
| **Navigation**    | vim-tmux-navigator, Trouble                               |

### Key Bindings

**File Navigation:**
| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | List buffers |
| `<leader>e` | Open Oil at file |
| `<leader>E` | Open Oil at cwd |

**Buffer Management:**
| Key | Action |
|-----|--------|
| `<left>` | Previous buffer |
| `<right>` | Next buffer |
| `<up>` | Close other buffers |
| `<leader>bc` | Close buffer |

**LSP:**
| Key | Action |
|-----|--------|
| `<leader>gd` | Go to definition |
| `<leader>gD` | Go to declaration |
| `<leader>gi` | Go to implementation |
| `<leader>k` | Code action |
| `<leader>mp` | Format file |

**Diagnostics:**
| Key | Action |
|-----|--------|
| `<leader>tt` | Toggle Trouble diagnostics |
| `<leader>?` | Show buffer keymaps |

**Multi-cursor:**
| Key | Action |
|-----|--------|
| `C-n` | Add cursor at word |
| `C-Up` | Add cursor up |
| `C-Down` | Add cursor down |

---

## Runtime and Version Management

### Mise

**File:** `mise/config.toml`

Runtime version manager (formerly rtx).

```toml
[tools]
bun = "latest"
go = "latest"
node = "22"
```

### Homebrew

**File:** `homebrew/Brewfile`

Key packages:

| Category   | Packages                                                      |
| ---------- | ------------------------------------------------------------- |
| Shell      | zsh-autosuggestions, zsh-history-substring-search, oh-my-posh |
| Editor     | neovim, zed (implied via wezterm)                             |
| Dev Tools  | git, gh, fzf, ripgrep, fd, jq, delta, diff-so-fancy           |
| Languages  | node (via mise), go (via mise), python@3.13, openjdk@17       |
| Containers | docker-desktop                                                |
| DB         | mongodb-community, mongodb-atlas-cli                          |
| Terminal   | tmux, wezterm, btop, yazi, lsd, zoxide                        |
| AI         | opencode, claude, chatgpt                                     |

---

## OpenCode Configuration

AI agent configuration providing specialized agents, reusable skills, and workflow commands.

### Structure

```
opencode/
├── agent/              # Specialized AI agents
├── command/            # Workflow commands (/slash commands)
├── skill/              # Reusable expertise modules
└── templates/          # Document templates (PRD, SDD, etc.)
```

## Yadm

**Files:** `yadm/bootstrap`, `yadm/config`

Bootstrap script automates:

1. Homebrew bundle installation
2. TPM (Tmux Plugin Manager) setup
3. WezTerm terminfo configuration

```bash
# Check tracked files
yadm list

# Add new dotfile
yadm add ~/.config/new-config

# Commit and push
yadm commit -m "Add new config"
yadm push
```
