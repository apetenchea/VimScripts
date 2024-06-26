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

" Mappings {{{

" Exit insert mode.
inoremap jk <ESC>

" Scrolling.
nnoremap <UP> <C-Y>
nnoremap <DOWN> <C-E>

" Move through splits.
nnoremap <LEFT> <C-w>h
nnoremap <RIGHT> <C-w>l

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

" }}}
