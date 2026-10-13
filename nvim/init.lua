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

-- Example: export NVIM_CLANGD_PROJECTS="$HOME/project-one:$HOME/project-two"
local clangd_projects = {}
for _, dir in ipairs(vim.split(vim.env.NVIM_CLANGD_PROJECTS or "", ":", {
  plain = true,
  trimempty = true,
})) do
  dir = vim.trim(dir)
  if dir ~= "" then
    local path = vim.fn.fnamemodify(vim.fn.expand(dir), ":p")
    local realpath = vim.uv.fs_realpath(path)
    if realpath then
      clangd_projects[vim.fs.normalize(realpath)] = true
    end
  end
end

vim.lsp.config("clangd", {
  cmd = { "clangd", "--background-index" },
  root_dir = function(bufnr, on_dir)
    local file = vim.uv.fs_realpath(vim.api.nvim_buf_get_name(bufnr))
    if not file then
      return
    end
    local root = vim.fs.root(file, "compile_commands.json")
    if root and clangd_projects[vim.fs.normalize(root)]
      and vim.fn.filereadable(root .. "/compile_commands.json") == 1
    then
      on_dir(root)
    end
  end,
})
vim.lsp.enable("clangd")

-- Example: export NVIM_PYRIGHT_PROJECTS="$HOME/project-one:$HOME/project-two"
local pyright_projects = {}
for _, dir in ipairs(vim.split(vim.env.NVIM_PYRIGHT_PROJECTS or "", ":", {
  plain = true,
  trimempty = true,
})) do
  dir = vim.trim(dir)
  if dir ~= "" then
    local path = vim.fn.fnamemodify(vim.fn.expand(dir), ":p")
    local realpath = vim.uv.fs_realpath(path)
    if realpath and vim.fn.isdirectory(realpath) == 1 then
      table.insert(pyright_projects, vim.fs.normalize(realpath))
    end
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
vim.api.nvim_create_user_command("BC", function(opts)
  require("beyond_compare").open(opts.args)
end, { nargs = "?", desc = "Beyond Compare: current file versus index or Git revision" })
vim.cmd([[cnoreabbrev <expr> bc getcmdtype() == ':' && getcmdline() ==# 'bc' ? 'BC' : 'bc']])

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
