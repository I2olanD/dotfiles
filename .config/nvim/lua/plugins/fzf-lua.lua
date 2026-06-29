local fzf = require("fzf-lua")
fzf.setup({
  grep = {
    -- rg respects .gitignore by default (no --no-ignore here).
    -- --hidden lets it search dotfiles, while .gitignore rules still apply.
    rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 --hidden -e",
  },
  files = {
    -- same idea for `<leader>ff` (FzfLua files), which uses fd
    fd_opts = "--color=never --type f --hidden --follow",
  },
})
fzf.register_ui_select()
