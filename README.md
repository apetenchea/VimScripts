# VimScripts
Some vim scripts that make my life easier.<br>
<hr>

# Current setup
Quite minimalist, with only a few key mappings. See my current [vimrc](vimrc)

Using the following plugins:
1. [pathogen](https://github.com/tpope/vim-pathogen)
2. [nerdtree](https://github.com/scrooloose/nerdtree)

# Old setup
I'm keeping the old setup here for fun.  
I used to have the following plugins installed:

1. [pathogen](https://github.com/tpope/vim-pathogen)
2. [nerdtree](https://github.com/scrooloose/nerdtree)
3. [vim-localvimrc](https://github.com/embear/vim-localvimrc)
4. [syntastic](https://github.com/vim-syntastic/syntastic)
5. [YouCompleteMe](https://github.com/Valloric/YouCompleteMe)
6. [rust.vim](https://github.com/rust-lang/rust.vim)
<hr>

## [vimrc](vimrc_old)
My .vimrc file. Nowadays it's actually much more minimalist, but my nostalgia makes me keep this one up here.
<hr>

## [ideavimrc](ideavimrc)
My .ideavimrc file. I use it together with [IdeaVim](https://github.com/JetBrains/ideavim) when coding in JetBrains IDEs.
<hr>

## [eclim-extra](eclim-extra)
This script adds some features on top of the [Eclim](https://github.com/ervandew/eclim) plugin. 
The lack of a command which could start Eclim from within Vim was annoying.
The `StartEclim` command in this script does exactly just that!<br>
*How it works*<br>
It first checks if the Eclim server is already running. If not, it starts it in background. When the Vim instance which started the server is closed, the server is also stopped automatically.<br>
Also, this script adds some nice features that go along with Eclim, such as Javadoc comment folding and useful mappings.<br>

**Configuration**<br>
Details about Eclim can be found [here](http://eclim.org/).<br>
*Set `s:eclimd_path` to the path of your Eclim server*<br>
The variable `s:eclimd_path` should contain the path to *eclimd*, which can be found in the folder where Eclim was installed.<br>
*Using vim-localvimrc*<br>
The best way to use eclim-extra is alongside [vim-localvimrc](https://github.com/embear/vim-localvimrc). This will enable you to automatically run the Eclim server in background, whenever Vim is started inside your Eclipse workspace. If not, you can manually start it by using the `StartEclim` command.<br>
After you've installed vim-localvimrc, you should disable sandbox mode. Add this to your .vimrc:
```Vim script
" Disable sandbox mode for localvimrc.
g:localvimrc_sandbox = 0
```
In order to load .lvimrc files automatically, without asking, add this to your .vimrc:
```Vim script
" Don't ask before loading a .lvimrc file.
g:localvimrc_ask = 0
```
NOTE: if there are multiple users on the same machine, first make sure that it is safe to disable sanbox mode!<br>
Then, simply put the contents of the eclim-extra script inside a file named *.lvimrc*, created in your eclipse workspace.<br>
Now, the Eclim server will start automatically with Vim, inside the Eclipse workspace.<br>
When you don't want the Eclim server to be started automatically, you can start Vim like this:
```Bash
vim --cmd 'let g:noeclim=1' 
```

**Usage**<br>
To start the Eclim server from whithin Vim use:
```Vim script
:StartEclim
```

**Mappings**<br>
1. *CTRL+b* -> build project + toggle quickfix window.

**Tips**<br>
1. Regarding Eclim and [checkstyle](checkstyle.sourceforge.net), I ran into some problems, which I fixed by following [this](https://www.chromium.org/developers/checkstyle) advice.<br>
2. How to check your default Eclipse workspace:
    1. Go to $HOME/eclipse/configuration
    2. In the *config.ini* file you should see a line:
    ```
      osgi.instance.area.default=your_default_workspace
    ```

**About the code**<br>
The code aims to follow the [Google Vimscript Style Guide](https://google.github.io/styleguide/vimscriptguide.xml).
