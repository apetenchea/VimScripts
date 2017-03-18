# VimScripts
Some vim scripts that make my life easier.<br>
The code aims to follow the [Google Vimscript Style Guide](https://google.github.io/styleguide/vimscriptguide.xml).
<hr>

## [vimrc](vimrc)
My .vimrc file.<br>
I have the following installed:
1. [eclim](https://github.com/ervandew/eclim)
2. [pathogen](https://github.com/tpope/vim-pathogen)
3. [nerdtree](https://github.com/scrooloose/nerdtree)
4. [syntastic](https://github.com/vim-syntastic/syntastic)
5. [vim-fugitive](https://github.com/tpope/vim-fugitive)
6. [YouCompleteMe](https://github.com/Valloric/YouCompleteMe)
7. [vim-localvimrc](https://github.com/embear/vim-localvimrc)
8. [merlin](https://github.com/ocaml/merlin)
<hr>

## [eclim-extra](eclim-extra)
This is a script meant to add some features on top of [eclim](https://github.com/ervandew/eclim).<br>
The best way to use it is alongside [vim-localvimrc](https://github.com/embear/vim-localvimrc) in order to autoamtically run the Eclim
server in background, in case vim is started inside the eclipse workspace. Lack of a command which could start eclim was annoying.
The *:StartEclim* command from this script does exactly just that! It first checks if the eclim server is already running, and if not,
it starts it in background. The server is also stopped automatically when the Vim instance which started it is being closed.<br>
Also, this script adds some nice features that go along well with the java-eclim combination, such as javadoc comment folding and a mapping
to build the project and display the quickfix window.<br>

***Configuration***<br>

Details about eclim [here](http://eclim.org/).<br>
In order to have eclimd started automatically when you work on a project in your eclipse workspace, first
install [vim-localvimrc](https://github.com/embear/vim-localvimrc).<br>
After this, you should disable sandbox mode. Add to .vimrc:
```Vim script
" Disable sandbox mode for localvimrc
g:localvimrc_sandbox = 0
```
In order to load .lvimrc files automatically, without asking, add to .vimrc:
```Vim script
" Don't ask before loading a .lvimrc file
g:localvimrc_ask = 0
```
NOTE: if there are multiple users on the same machine, make sure first that it is safe to disable sanbox mode!<br>
Next, check that the variable `s:eclimd_path` points to *eclimd*, which can be found where Eclim was installed.<br>
Then simply put this script inside a file named *.lvimrc*, in your eclipse workspace.
To check the default eclipse workspace<br>
1. Go to $HOME/eclipse/configuration
2. In the *config.ini* file you should see a line:
  ```
  osgi.instance.area.default=your_default_workspace
  ```
***Usage***<br>

If you don't want the eclim server to be started automatically, you can start vim like this:
```
vim --cmd 'let g:noeclim=1' 
```
To start Eclim from inside Vim use:
```Vim script
:StartEclim
```
***Mappings***<br>

1. CTRL+b -> build project + display quickfix window, or hide the quickfix window in case it is already open.
<hr>
