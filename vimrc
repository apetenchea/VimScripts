" Use Vim settings, rather than Vi settings.
" This must be first, because it changes other options as a side effect.
set nocompatible

" Settings {{{

" Set folding.
set foldmethod=marker

" Allow backspacing over everything in insert mode.
set backspace=indent,eol,start

" Show the cursor position all the time.
set ruler

" Display partial commands.
set showcmd

" Disable line wrapping.
set nowrap

" Display line numbers.
set number

" Set the width of the column containing line numbers.
set numberwidth=1

" Tab characters appear 2 spaces wide.
set tabstop=2

" Use spaces instead of tab.
set expandtab

" An indent corresponds to a single tab.
set shiftwidth=2

" Disable empty windows for mksession
set sessionoptions-=blank

" }}}

" Autocommands {{{

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Load indentation rules and plugins according to the detected filetype.
  filetype plugin indent on

  augroup vimrc
    autocmd!

    " When editiong a file, always jump to the last known cursor position.
    autocmd BufReadPost *
          \ if line("'\"") > 1 && line("'\"") <= line("$") |
          \ 	exe "normal! g'\"" |
          \ endif
  augroup END

else

  " Set autoindent on.
  set autoindent

endif

" }}}

" Variables {{{

" Leader key for mappings.
let mapleader = '-'

" Leader key for file type specific mappings.
let maplocalleader = '\'

" }}}

" Functions {{{

" Use YcmCompleter GoTo if it is supported, otherwise fall back to built-in gd.
function! s:GoTo()
  let l:ycm_support = ['c', 'cpp', 'rust', 'python']
  if index(l:ycm_support, &filetype) == -1
    normal! gd
  else
    silent execute 'YcmCompleter GoTo'
  endif
endfunction

" }}}

" Mappings {{{

" Exit insert mode.
inoremap jk <ESC>

" Open brackets.
inoremap kk <C-G>u{<CR>}<ESC>O

" Scrolling.
nnoremap <UP> <C-Y>
nnoremap <DOWN> <C-E>

" Move through splits.
nnoremap <LEFT> <C-w>h
nnoremap <RIGHT> <C-w>l

" Sensible go to from YCM.
nnoremap <silent> <Space> :call <SID>GoTo()<CR>

" Check for errors.
nnoremap <silent> <CR> :SyntasticCheck<CR>

" Clear errors.
nnoremap <silent> <BS> :SyntasticReset<CR>

" }}}

" Appearence {{{

" Set background color.
set background=dark

" Disable preview window (pops up on autocomplete).
set completeopt-=preview

" Enable syntax highlighting.
syntax on

" Set colorscheme and autocomplete window color.
if has("gui_running")
  colorscheme murphy
  highlight Pmenu guifg=white guibg=black
  highlight PmenuSel guifg=darkgrey guibg=black
else
  colorscheme elflord
  highlight Pmenu ctermfg=white ctermbg=black
endif

" Default font.
set guifont=Monospace\ 18

" Remove gui tools.
set guioptions=c

" }}}

" Plugins {{{

" Run pathogen.
execute pathogen#infect()

" Shortcut for NERDTree.
nnoremap <C-n> :NERDTreeToggle<CR>

" Don't ask before loading a .lvimrc file.
let g:localvimrc_ask = 0

" Syntastic settings.
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 0

" Syntastic checkers.
let g:syntastic_python_checkers = ['python']
let g:syntastic_sh_checkers = ['shellcheck']
let g:syntastic_rust_checkers = ['cargo']
let g:syntastic_c_checkers = ['clang_check']
let g:syntastic_c_compiler_options = '-std=c11'
let g:syntastic_cpp_checkers = ['clang_check']
let g:syntastic_cpp_compiler_options = '-std=c++11'

let g:syntastic_mode_map = {
  \ 'mode': 'passive',
  \ 'active_filetypes': ['python'],
  \ 'passive_filetypes': []}

" YCM python used to run jedi.
let g:ycm_python_binary_path = 'python'

" Do not use YCM syntax checking, rely on syntastic instead.
let g:ycm_show_diagnostics_ui = 0

" YCM completion options for C-family.
let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'

" YCM autocompletion pops up only on <C-Space>.
let g:ycm_auto_trigger = 0

" }}}
