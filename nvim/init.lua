vim.g.mapleader = " "
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local opt = vim.opt
opt.clipboard = "unnamedplus"
opt.timeoutlen = 300
opt.number = true
opt.numberwidth = 1
opt.wrap = false
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.foldmethod = "marker"
opt.signcolumn = "yes"
opt.sessionoptions:remove("blank")
opt.sessionoptions:remove("buffers")
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
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/nvim-tree/nvim-tree.lua",
  "https://github.com/nvim-tree/nvim-web-devicons",
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("CodeNavigation", { clear = true }),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then
      return
    end

    local function bind(key, method, action, desc)
      if client:supports_method(method, ev.buf) then
        vim.keymap.set("n", key, action, { buffer = ev.buf, desc = desc })
      end
    end

    bind("<leader>u", "textDocument/references", function()
      vim.lsp.buf.references({ includeDeclaration = false })
    end, "Find usages")
    bind("gd", "textDocument/definition", vim.lsp.buf.definition, "Go to definition")
    bind("gD", "textDocument/declaration", vim.lsp.buf.declaration, "Go to declaration")
  end,
})

local function env_list(name)
  local entries = {}
  for _, entry in ipairs(vim.split(vim.env[name] or "", ":", { plain = true, trimempty = true })) do
    entry = vim.trim(entry)
    if entry ~= "" then
      table.insert(entries, entry)
    end
  end
  return entries
end

-- Example: export NVIM_CLANGD_PROJECTS="$HOME/project-one:$HOME/project-two"
local clangd_projects = {}
for _, dir in ipairs(env_list("NVIM_CLANGD_PROJECTS")) do
  local path = vim.fn.fnamemodify(vim.fn.expand(dir), ":p")
  local realpath = vim.uv.fs_realpath(path)
  if realpath then
    clangd_projects[vim.fs.normalize(realpath)] = true
  end
end

vim.lsp.config("clangd", {
  cmd = { "clangd", "--background-index" },
  root_dir = function(bufnr, on_dir)
    local name = vim.api.nvim_buf_get_name(bufnr)
    if name == "" then
      return
    end
    -- New files have no realpath yet; resolve their parent to retain symlink handling.
    local path = vim.uv.fs_realpath(name) or vim.uv.fs_realpath(vim.fs.dirname(name))
    if not path then
      return
    end
    local root = vim.fs.root(path, "compile_commands.json")
    if root and clangd_projects[vim.fs.normalize(root)]
      and vim.fn.filereadable(root .. "/compile_commands.json") == 1
    then
      on_dir(root)
    end
  end,
})
vim.lsp.enable("clangd", next(clangd_projects) ~= nil)

-- Example: export NVIM_PYRIGHT_PROJECTS="$HOME/project-one:$HOME/project-two"
local pyright_projects = {}
for _, dir in ipairs(env_list("NVIM_PYRIGHT_PROJECTS")) do
  local path = vim.fn.fnamemodify(vim.fn.expand(dir), ":p")
  local realpath = vim.uv.fs_realpath(path)
  if realpath and vim.fn.isdirectory(realpath) == 1 then
    table.insert(pyright_projects, vim.fs.normalize(realpath))
  end
end
table.sort(pyright_projects, function(a, b)
  return #a > #b
end)

vim.lsp.config("pyright", {
  root_dir = function(bufnr, on_dir)
    local name = vim.api.nvim_buf_get_name(bufnr)
    if name == "" then
      return
    end
    local file = vim.fs.normalize(vim.uv.fs_realpath(name) or name)
    for _, root in ipairs(pyright_projects) do
      local prefix = root == "/" and root or root .. "/"
      if file:sub(1, #prefix) == prefix then
        on_dir(root)
        return
      end
    end
  end,
})
vim.lsp.enable("pyright", #pyright_projects > 0)

require("gitsigns").setup()
require("nvim-tree").setup({
  update_focused_file = { enable = true },
  git = { timeout = 5000 },
})
require("which-key").setup({
  delay = 400,
  icons = { mappings = false },
})

-- Example: export NVIM_SESSION_DIRS="$HOME/project-one:$HOME/project-two"
local session_dirs = env_list("NVIM_SESSION_DIRS")

require("auto-session").setup({
  enabled = #session_dirs > 0,
  allowed_dirs = session_dirs,
})

vim.cmd.colorscheme("catppuccin-mocha")
vim.env.BAT_THEME = "Catppuccin Mocha"

-- Search nested and symlinked repositories, including .git/info/exclude entries.
-- Retain .gitignore rules and skip Git metadata in every repository.
local rg_command = "rg --hidden --follow --no-ignore-exclude -g '!.git'"
vim.env.FZF_DEFAULT_COMMAND = rg_command .. " --files"
local rg_search = rg_command .. " --column --line-number --no-heading --color=always --smart-case -- "

vim.api.nvim_create_user_command("Rg", function(opts)
  vim.fn["fzf#vim#grep"](
    rg_search .. vim.fn["fzf#shellescape"](opts.args),
    vim.fn["fzf#vim#with_preview"](), opts.bang and 1 or 0
  )
end, { nargs = "*", bang = true, desc = "Search files, then fuzzy-filter matches" })

vim.api.nvim_create_user_command("RG", function(opts)
  vim.fn["fzf#vim#grep2"](
    rg_search, opts.args, vim.fn["fzf#vim#with_preview"](), opts.bang and 1 or 0
  )
end, { nargs = "*", bang = true, desc = "Search files as you type" })

local map = vim.keymap.set
map("c", "<CR>", function()
  if vim.fn.getcmdtype() == "/" and vim.fn.getcmdline() == "" then
    return "<C-c><Cmd>nohlsearch<CR>"
  end
  return "<CR>"
end, { expr = true, desc = "Clear highlights on an empty search" })
map("n", "<leader>t", "<Cmd>NvimTreeToggle<CR>", { desc = "tree" })
vim.api.nvim_create_user_command("BC", function(opts)
  require("beyond_compare").open(opts.args)
end, { nargs = "?", desc = "Beyond Compare: current file versus index or Git revision" })
vim.cmd([[cnoreabbrev <expr> bc getcmdtype() == ':' && getcmdline() ==# 'bc' ? 'BC' : 'bc']])

map("i", "jk", "<Esc>")
map("n", "<Left>", "<C-w>h")
map("n", "<Right>", "<C-w>l")
map("n", "<leader>f", "<Cmd>Files<CR>", { desc = "File" })
map("n", "<leader>s", "<Cmd>RG<CR>", { desc = "Search" })
map("n", "<leader>o", "<Cmd>Buffers<CR>", { desc = "Open buffer" })
map("n", "<leader>b", "<Cmd>Gitsigns blame<CR>", { desc = "Blame" })
map("n", "<leader>d", "<Cmd>Gvdiffsplit<CR>", { desc = "Diff" })
map("n", "]c", function()
  if vim.wo.diff then
    vim.cmd.normal({ "]c", bang = true })
  else
    require("gitsigns").nav_hunk("next")
  end
end, { desc = "Next change" })
map("n", "[c", function()
  if vim.wo.diff then
    vim.cmd.normal({ "[c", bang = true })
  else
    require("gitsigns").nav_hunk("prev")
  end
end, { desc = "Previous change" })
