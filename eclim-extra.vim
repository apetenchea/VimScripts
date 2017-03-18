" Some useful features added on top of Eclim (http://eclim.org/).
" In order to use this you should have Eclim installed.
" This was written to work on Linux, but it can be easily adapted to Windows.
"
" Maintainer: Alexandru Petenchea
"
" The best way to use it is as a .lvimrc file, inside the eclipse
" workspace. In order to use local vim configuration files, install localvimrc
" (https://github.com/embear/vim-localvimrc).
" Note:
" If you are using localvimrc, sanbox mode should be disabled! Add in .vimrc:
" let g:localvimrc_sandbox = 0
"
" If you have localvimrc installed, and you don't want Eclim to start when
" this script is loaded, just start Vim like this:
" vim --cmd 'let g:noeclim=1' 
"
" To manually start eclim, use the command :StartEclim

" Section: Settings {{{1

" Fold javadoc comments.
setlocal foldmethod=marker
setlocal foldmarker=/**,*/
setlocal foldcolumn=1

if exists('g:localvimrc_sourced_once') && g:localvimrc_sourced_once
  finish
endif

" Section: Variables {{{1

" Path to eclimd.
let s:eclimd_path = eclim#UserHome().'/eclipse/eclimd'

" Concatenate this to a shell command in order to ignore its output.
let s:ignore_output = '> /dev/null 2>&1'

" Concatenate this to a shell command in order to run it in background.
let s:start_in_background = '&'

" Open/close status of the quickfix window.
let s:quickfix_is_open = 0

" The eclimd status at the start of this script.
let s:eclimd_already_running = 0

" Section: Functions {{{1

" Function: s:StartEclim() {{{2
"
" If eclimd is not already running, start it in background.
" Returns 1 if eclimd is already running, 0 otherwise.
function! s:StartEclim()
  let l:is_eclimd_running = system('pgrep eclimd') 
  if strlen(l:is_eclimd_running) > 0
    return 1
  endif
  silent execute '!'.s:eclimd_path.' '.s:ignore_output.' '.s:start_in_background
  return 0
endfunction

" Function: s:DoCleanup() {{{2
"
" Stops Eclim, only if it was started by this script.
" To be used at VimLeave.
function! s:DoCleanup()
  if exists('g:noeclim') || s:eclimd_already_running
    return
  else
    let l:is_eclimd_running = system('pgrep eclimd')
    if strlen(l:is_eclimd_running) == 0
      return
    endif
    silent execute 'ShutdownEclim'
  endif
  let l:is_eclimd_running = system('pgrep eclimd') 
endfunction

" Function: s:ToggleBuild() {{{2
"
" If the quickfix window is closed, build the project and show the quickfix
" window. Otherwise, close the quickfix window. This is to be used by a
" mapping, in order to quickly check the build status.
function! s:ToggleBuild()
  if s:quickfix_is_open == 1
    cclose
    let s:quickfix_is_open = 0
  else
    silent execute 'ProjectBuild'
    silent execute 'ProjectProblems'
    let s:quickfix_is_open = 1
  endif
endfunction

" Section: Mappings {{{1

" Use CTRL+b to open/close the quickfix window with the build status.
nnoremap <silent> <C-b> :call <SID>ToggleBuild()<CR>

" Section: Autocommands {{{1

" Do the cleanup before leaving Vim.
augroup do_cleanup
  autocmd!
  autocmd VimLeave * :call <SID>DoCleanup()
augroup END

" Section: Command declarations {{{1

if !exists(':StartEclim')
  command StartEclim :call <SID>StartEclim()
endif

" Section: Start Eclim {{{1

if !exists('g:noeclim')	
  let s:eclimd_already_running = <SID>StartEclim()
endif
