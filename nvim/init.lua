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
})

require("gitsigns").setup()

vim.cmd.colorscheme("catppuccin-mocha")

local map = vim.keymap.set
map("i", "jk", "<Esc>")
map("n", "<Up>", "<C-y>")
map("n", "<Down>", "<C-e>")
map("n", "<Left>", "<C-w>h")
map("n", "<Right>", "<C-w>l")
map("n", "<leader>f", "<Cmd>GFiles<CR>", { desc = "Find tracked file" })
map("n", "<leader>s", "<Cmd>Rg<CR>", { desc = "Search source text" })
map("n", "<leader>b", "<Cmd>Buffers<CR>", { desc = "Find open buffer" })
map("n", "<leader>g", "<Cmd>Git<CR>", { desc = "Git status" })
map("n", "<leader>d", "<Cmd>Gdiffsplit<CR>", { desc = "Diff current file" })
