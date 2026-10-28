# VimScripts
Some vim scripts that make my life easier.<br>
<hr>

# Current setup

My [Neovim](#neovim) and [Ghostty](#ghostty) configurations are documented below. The Vim setup is retained for reference.

# Vim setup

Quite minimalist, with only a few key mappings. See [vimrc](vimrc).

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

# Neovim

Configuration lives in [nvim/init.lua](nvim/init.lua), with the Beyond Compare command in [nvim/lua/beyond_compare.lua](nvim/lua/beyond_compare.lua).

## Setup

Tested with Neovim 0.12.6. The configuration uses the built-in `vim.pack` plugin manager and `vim.lsp.config` / `vim.lsp.enable` APIs.

Install these executables on `PATH`:

- `git`, `fzf`, and `rg` (ripgrep) for plugins, Git integration, and search.
- `bat` for syntax-highlighted previews, with the `Catppuccin Mocha` theme available in `bat --list-themes`.
- `clangd` for C/C++ projects and `pyright-langserver` for Python projects, if enabled below.
- Beyond Compare's `bcomp` or `bcompare` launcher for `:BC`. Git resolves the launcher; use `difftool.bc.path` to configure a custom location.

A Nerd Font is useful for the file-tree icons. Language servers and external tools are installed separately from the plugins.

Link this repository's `nvim` directory to your Neovim configuration directory. For the default Unix location, from the repository root, with no existing `~/.config/nvim`:

```sh
mkdir -p "$HOME/.config"
ln -s "$PWD/nvim" "$HOME/.config/nvim"
```

If `XDG_CONFIG_HOME` is set, use `$XDG_CONFIG_HOME/nvim` instead. Start `nvim` and accept the initial plugin installation. Keep [nvim/nvim-pack-lock.json](nvim/nvim-pack-lock.json) under version control; it records the plugin revisions used for a fresh installation. Use `:lua vim.pack.update()` to review and apply plugin updates, then commit the lockfile changes.

## Project configuration

Set these optional variables in the shell that launches Neovim. Each accepts a colon-separated list; empty entries and surrounding whitespace are ignored.

```sh
export NVIM_CLANGD_PROJECTS="$HOME/src/cpp-project:$HOME/src/another-cpp-project"
export NVIM_PYRIGHT_PROJECTS="$HOME/src/python-project"
export NVIM_SESSION_DIRS="$HOME/src/cpp-project:$HOME/src/python-project"
```

Unset variables disable the corresponding language server or automatic sessions. Restart Neovim after changing them.

- `NVIM_CLANGD_PROJECTS`: exact allowed project roots. The nearest ancestor containing a readable `compile_commands.json` must match an entry after resolving symlinks. A parent directory does not automatically allow nested projects. If the compilation database lives in a build directory, link it into the source root. New files are supported when their parent directory exists.
- `NVIM_PYRIGHT_PROJECTS`: allowed Python project roots. Files beneath an entry use that directory as the LSP root; the longest matching entry wins. These explicit roots replace automatic project-marker discovery. Nonexistent LSP project paths are silently ignored.
- `NVIM_SESSION_DIRS`: working directories allowed for automatic session saving and restoration. Auto-session also accepts glob patterns, such as `$HOME/src/**`. Start `nvim` without file arguments from an allowed directory to restore its session. By default, launching with file arguments skips automatic restoration and saving.

Sessions retain window layouts and local options, but exclude blank windows and hidden buffers. Files that are open only in the buffer list will not be restored. The auto-session health warning about missing `buffers` reflects this setting.

## Commands and mappings

Run `:Cheatsheet` (or `:help my-cheatsheet`) for the personal reference, including Git status, diff inspection, and rollback commands. Search it with `/`, follow help links with `Ctrl-]`, and close it with `Ctrl-W q`. Its source is [nvim/doc/my-cheatsheet.txt](nvim/doc/my-cheatsheet.txt).

The leader key is Space. These mappings use Normal mode unless stated otherwise.

| Key | Action |
| --- | --- |
| `<Space>f` | Find files (`:Files`) |
| `<Space>s` | Search contents as you type (`:RG`) |
| `<Space>o` | List open buffers |
| `<Space>t` | Toggle the file tree |
| `<Space>b` | Show Git blame |
| `<Space>g` | Toggle all Git gutters between `main` and the index (`:Gbase`) |
| `<Space>d` | Open a vertical Git diff |
| `[c` / `]c` | Previous / next Git hunk, or diff change in diff mode |
| `gd` / `gD` | Go to definition / declaration, when supported by an attached LSP |
| `<Space>u` | Find references, excluding declarations, when supported by an attached LSP |
| Left / Right | Move to the window on the left / right |
| `jk` in Insert mode | Return to Normal mode; mapping timeout is 300 ms |

`:Files`, `:Rg`, and `:RG` include hidden files and follow symlinks. They respect `.gitignore`, include paths excluded only by `.git/info/exclude`, and skip `.git` metadata. `:Rg pattern` searches once and fuzzy-filters the results; `:RG pattern` reruns the search as you type. Searches start from the current working directory.

`:BC` compares the saved current file against the Git index. `:BC HEAD` (or another commit, branch, or tag) compares it against that revision. Save edits first. The command uses `git difftool --tool=bc` asynchronously; unchanged files produce no comparison window. Lowercase `:bc` expands to `:BC`.

For diagnosis, run `:checkhealth vim.pack vim.lsp auto-session which-key`. If an LSP does not attach, check its executable on `PATH`, its project variable, and, for clangd, the compilation database location.

`:Gchanges` (or `<Space>c`) lists working tree differences against the tip of `main`, including committed, staged, and unstaged changes to tracked files. Use `:Gchanges develop` to choose another target; Tab completes Git refs. Save buffers first; untracked files require `git add` before they appear. It runs Fugitive's `:Git difftool --name-only base`. Press Enter on a quickfix entry to open it, or use `:copen` to reopen the list.

`:Gbase` toggles Gitsigns' baseline globally, including files opened later, and reports the selected baseline. It starts with the index each Neovim session. Hunk navigation, previews, and resets follow the selected baseline; switch back to the index before discarding only unstaged changes. This does not change the target used by `:Gchanges`.

# Ghostty

Terminal configuration lives in [ghostty/config](ghostty/config). This setup is intended for macOS.

## Setup

Install Ghostty and make sure the Andale Mono font is available. From the repository root, with no existing `~/.config/ghostty`:

```sh
mkdir -p "$HOME/.config"
ln -s "$PWD/ghostty" "$HOME/.config/ghostty"
```

If `XDG_CONFIG_HOME` is set, use `$XDG_CONFIG_HOME/ghostty` instead. Ghostty also loads configuration from `~/Library/Application Support/com.mitchellh.ghostty/` on macOS; values there can override this repository's settings. The `config` filename remains supported alongside `config.ghostty`. See the [configuration documentation](https://ghostty.org/docs/config#file-location).

## Settings and shortcuts

- Andale Mono at 18 points with the built-in Catppuccin Mocha theme, matching Neovim and bat. The theme supplies the text, background, cursor, and selection colors.
- A non-blinking block cursor. `shell-integration-features = no-cursor` prevents shell integration from changing it to a bar; terminal applications can still change the cursor themselves.
- Eight points of horizontal padding and six points of vertical padding.
- The mouse pointer hides while typing, and window state is saved on exit.
- Left Option acts as Alt for terminal shortcuts; right Option retains macOS character input.
- Control + grave accent toggles a quick terminal at the top of the screen, using 40% of its height. The shortcut is global while Ghostty is running.

On macOS, the global shortcut requires Ghostty to have Accessibility access in System Settings → Privacy & Security → Accessibility. See the [keybinding reference](https://ghostty.org/docs/config/reference#keybind).

Reload configuration with Command + Shift + comma. Some changes require a new terminal or an application restart. To validate this file from the repository root without opening a terminal window:

```sh
/Applications/Ghostty.app/Contents/MacOS/ghostty +validate-config --config-file="$PWD/ghostty/config"
```

If `ghostty` is on `PATH`, it can replace the application-bundle path above.
