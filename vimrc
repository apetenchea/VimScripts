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

" Set the width of the column containing line numbers.
set numberwidth=1

" Tab characters appear 2 spaces wide.
set tabstop=2

" Use spaces instead of tab.
set expandtab

" An indent corresponds to a single tab.
set shiftwidth=2

" Load plugin files for specific file types.
filetype plugin on

" Load indent file for specific file types.
filetype indent on

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
let mapleader = ','

" Leader key for file type specific mappings.
let maplocalleader = "-"

"}}}

" Mappings {{{

" Exit insert mode.
inoremap jk <ESC>

" Open brackets.
inoremap kl <C-G>u{<CR>}<ESC>O

" Scrolling.
nnoremap <UP> <C-Y>
nnoremap <DOWN> <C-E>

" Move through splits.
nnoremap <LEFT> <C-w>h
nnoremap <RIGHT> <C-w>l

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

" Shortcut for NERDTree.
nnoremap <C-n> :NERDTreeToggle<CR>

" Don't ask before loading a .lvimrc file.
let g:localvimrc_ask = 0

" Disable sandbox mode.
let g:localvimrc_sandbox = 0

" Disable YCM's syntax checkers.
let g:ycm_show_diagnostics_ui = 0

" Set Python 2 interpreter path.
let g:ycm_server_python_interpreter = '/usr/bin/python2'

" Provide Python 3 completion.
let g:ycm_python_binary_path = '/usr/bin/python3'

" Eclim completion to be used by YCM.
let g:EclimCompletionMethod = 'omnifunc'

" Disable Eclim automatic validation.
let g:EclimFileTypeValidate = 0

" Syntastic settings.
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 0

" Syntastic checkers.
let g:syntastic_c_checkers = ['clang_check','clang_tidy']
let g:syntastic_cpp_checker = ['clang_check','clang_tidy']
let g:syntastic_cpp_compiler_options = '-std=c++11'
let g:syntastic_java_checkers = ['javac']
let g:syntastic_sh_checkers = ['shellcheck']
let g:syntastic_python_checkers = ['python']
let g:syntastic_asm_checkers = []
let g:syntastic_ocaml_checkers = ['merlin']
let g:syntastic_html_checkers = ['w3']
let g:syntastic_php_checkers = ['php']

"}}}

" Opam user-setup {{{
" ## added by OPAM user-setup for vim / base ## b8bd57f3ee1aa5f9b7e05197a5a90cc8 ## you can edit, but keep this line
let s:opam_share_dir = system("opam config var share")
let s:opam_share_dir = substitute(s:opam_share_dir, '[\r\n]*$', '', '')

let s:opam_configuration = {}

function! OpamConfOcpIndent()
execute "set rtp^=" . s:opam_share_dir . "/ocp-indent/vim"
endfunction
let s:opam_configuration['ocp-indent'] = function('OpamConfOcpIndent')

function! OpamConfOcpIndex()
execute "set rtp+=" . s:opam_share_dir . "/ocp-index/vim"
endfunction
let s:opam_configuration['ocp-index'] = function('OpamConfOcpIndex')

function! OpamConfMerlin()
let l:dir = s:opam_share_dir . "/merlin/vim"
execute "set rtp+=" . l:dir
endfunction
let s:opam_configuration['merlin'] = function('OpamConfMerlin')

let s:opam_packages = ["ocp-indent", "ocp-index", "merlin"]
let s:opam_check_cmdline = ["opam list --installed --short --safe --color=never"] + s:opam_packages
let s:opam_available_tools = split(system(join(s:opam_check_cmdline)))
for tool in s:opam_packages
" Respect package order (merlin should be after ocp-index)
if count(s:opam_available_tools, tool) > 0
call s:opam_configuration[tool]()
endif
endfor
" ## end of OPAM user-setup addition for vim / base ## keep this line
" ## added by OPAM user-setup for vim / ocp-indent ## bf323b9aee5694dc684b7385ff4fbb87 ## you can edit, but keep this line
if count(s:opam_available_tools,"ocp-indent") == 0
source "/home/alex/.opam/system/share/vim/syntax/ocp-indent.vim"
endif
" ## end of OPAM user-setup addition for vim / ocp-indent ## keep this line
" }}}
