" vimrc file
"
" Maintainer:	Alexandru Petenchea
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

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

" Display line numbers relative to the current line.
set relativenumber
 
" Set the width of the column containing line numbers.
set numberwidth=1

" Tab characters appear 2 spaces wide.
set tabstop=2

" Use tab character.
set noexpandtab

" An indent corresponds to a single tab.
set shiftwidth=2

" Disable empty windows for mksession
set sessionoptions-=blank

"}}}

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

"}}}

" Variables {{{

" Leader key for mappings.
let mapleader=','

" Leader key for file type specific mappings.
let maplocalleader="-"

"}}}

" Mappings {{{

" Exit insert mode.
inoremap jk <ESC>

" Open brackets.
inoremap kl <C-G>u{<CR>}<ESC>O

" Scrolling.
nnoremap <UP> <C-Y>
nnoremap <DOWN> <C-E>

" Block indentation.
nnoremap <LEFT> <iB
nnoremap <RIGHT> >iB

"}}}

" Appearence {{{

" Set background color.
set background=dark

" Set theme.
colorscheme elflord


" Disable preview window (pops up on autocomplete).
set completeopt-=preview

" Enable syntax highlighting.
syntax on

" Change the color of line numbers.
highlight LineNr ctermfg=LightGray

" Change autocomplete window colors.
highlight Pmenu ctermfg=white ctermbg=black

"}}}

" Plugins {{{

" Run pathogen.
execute pathogen#infect()

" Shortcut for NERDTree
nnoremap <C-n> :NERDTreeToggle<CR>

" Don't ask before loading a .lvimrc file.
let g:localvimrc_ask=0

" Do not load lvimrc file in sandbox.
let g:localvimrc_sandbox=0

" Disable YCM's syntax checkers.
let g:ycm_show_diagnostics_ui=0

" Eclim completion to be used by YCM
let g:EclimCompletionMethod='omnifunc'

" Disable Eclim automatic validation.
let g:EclimFileTypeValidate=0

" Syntastic settings
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Syntastic checkers
let g:syntastic_c_checkers=['gcc']
let g:syntastic_java_checkers=['javac']
let g:syntastic_sh_checkers=['shellcheck']
let g:syntastic_asm_checkers=[]
let g:syntastic_ocaml_checkers=[]

"}}}
