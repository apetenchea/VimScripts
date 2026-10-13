vim.g.mapleader = " "

local opt = vim.opt
opt.number = true
opt.numberwidth = 1
opt.wrap = false
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.foldmethod = "marker"
opt.signcolumn = "yes"
opt.sessionoptions:remove("blank")
opt.sessionoptions:remove("options")
opt.sessionoptions:append("localoptions")

vim.cmd([[
  augroup RestoreCursor
    autocmd!
    autocmd BufReadPre * autocmd FileType <buffer> ++once
      \ let s:line = line("'\"")
      \ | if s:line >= 1 && s:line <= line("$") && &filetype !~# 'commit'
      \      && index(['xxd', 'gitrebase'], &filetype) == -1
      \      && !&diff
      \ |   execute "normal! g`\""
      \ | endif
  augroup END
]])

vim.pack.add({
  {
    src = "https://github.com/catppuccin/nvim",
    name = "catppuccin",
  },
  "https://github.com/junegunn/fzf",
  "https://github.com/junegunn/fzf.vim",
  "https://github.com/tpope/vim-fugitive",
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/folke/which-key.nvim",
  "https://github.com/rmagatti/auto-session",
})

require("gitsigns").setup()
require("which-key").setup({
  delay = 400,
})

-- Example: export NVIM_SESSION_DIRS="$HOME/project-one:$HOME/project-two"
local session_dirs = {}
for _, dir in ipairs(vim.split(vim.env.NVIM_SESSION_DIRS or "", ":", {
  plain = true,
  trimempty = true,
})) do
  dir = vim.trim(dir)
  if dir ~= "" then
    table.insert(session_dirs, dir)
  end
end

require("auto-session").setup({
  enabled = #session_dirs > 0,
  allowed_dirs = session_dirs,
})

vim.cmd.colorscheme("catppuccin-mocha")
vim.env.BAT_THEME = "Catppuccin Mocha"

local map = vim.keymap.set
map("i", "jk", "<Esc>")
map("n", "<Up>", "<C-y>")
map("n", "<Down>", "<C-e>")
map("n", "<Left>", "<C-w>h")
map("n", "<Right>", "<C-w>l")
map("n", "<leader>f", "<Cmd>GFiles<CR>", { desc = "Find tracked file" })
map("n", "<leader>s", "<Cmd>Rg<CR>", { desc = "Search source text" })
map("n", "<leader>b", "<Cmd>Buffers<CR>", { desc = "Find open buffer" })
map("n", "<leader>g", "<Cmd>Gitsigns blame<CR>", { desc = "Git blame" })
map("n", "<leader>d", "<Cmd>Gdiffsplit<CR>", { desc = "Diff current file" })
