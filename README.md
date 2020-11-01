# Asynchronous Lint Engine 

This repository contains only some configuration options for my personal usage
and `ALE` as a submodule.

![ALE Logo by Mark Grealish - https://www.bhalash.com/](https://user-images.githubusercontent.com/3518142/59195920-2c339500-8b85-11e9-9c22-f6b7f69637b8.jpg)

ALE (Asynchronous Lint Engine) is a plugin providing linting (syntax checking
and semantic errors) in NeoVim 0.2.0+ and Vim 8 while you edit your text files,
and acts as a Vim [Language Server Protocol](https://langserver.org/) client.

ALE makes use of NeoVim and Vim 8 job control functions and timers to
run linters on the contents of text buffers and return errors as
text is changed in Vim. This allows for displaying warnings and
errors in files being edited in Vim before files have been saved
back to a filesystem.

ALE offers support for fixing code with command line tools in a non-blocking
manner with the `:ALEFix` feature, supporting tools in many languages, like
`prettier`, `eslint`, `autopep8`, and more.

ALE acts as a "language client" to support a variety of Language Server Protocol
features, including:

* Diagnostics (via Language Server Protocol linters)
* Go To Definition (`:ALEGoToDefinition`)
* Completion (Built in completion support, or with Deoplete)
* Finding references (`:ALEFindReferences`)
* Hover information (`:ALEHover`)
* Symbol search (`:ALESymbolSearch`)

If you don't care about Language Server Protocol, ALE won't load any of the code
for working with it unless needed. One of ALE's general missions is that you
won't pay for the features that you don't use.

## Table of Contents

1. [Supported Languages and Tools](#supported-languages)
2. [Usage](#usage)
    1. [Linting](#usage-linting)
    2. [Fixing](#usage-fixing)
    3. [Completion](#usage-completion)
    4. [Go To Definition](#usage-go-to-definition)
    5. [Find References](#usage-find-references)
    6. [Hovering](#usage-hover)
    7. [Symbol Search](#usage-symbol-search)
3. [Installation](#installation)
    1. [Installation with Vim package management](#standard-installation)
    2. [Installation with Pathogen](#installation-with-pathogen)
    3. [Installation with Vundle](#installation-with-vundle)
    4. [Installation with Vim-Plug](#installation-with-vim-plug)
4. [Contributing](#contributing)

<a name="supported-languages"></a>

## 1. Supported Languages and Tools

ALE supports a wide variety of languages and tools. See the
[full list](supported-tools.md) in the
[Supported Languages and Tools](supported-tools.md) page.

<a name="usage"></a>

## 2. Usage

<a name="usage-linting"></a>

### 2.i Linting

Once this plugin is installed, while editing your files in supported
languages and tools which have been correctly installed,
this plugin will send the contents of your text buffers to a variety of
programs for checking the syntax and semantics of your programs. By default,
linters will be re-run in the background to check your syntax when you open
new buffers or as you make edits to your files.

The behavior of linting can be configured with a variety of options,
documented in [the Vim help file](doc/ale.txt). For more information on the
options ALE offers, consult `:help ale-options` for global options and `:help
ale-integration-options` for options specified to particular linters.

<a name="usage-fixing"></a>

### 2.ii Fixing

ALE can fix files with the `ALEFix` command. Functions need to be configured
either in each buffer with a `b:ale_fixers`, or globally with `g:ale_fixers`.

The recommended way to configure fixers is to define a List in an ftplugin file.

```vim
" In ~/.vim/ftplugin/javascript.vim, or somewhere similar.

" Fix files with prettier, and then ESLint.
let b:ale_fixers = ['prettier', 'eslint']
" Equivalent to the above.
let b:ale_fixers = {'javascript': ['prettier', 'eslint']}
```

You can also configure your fixers from vimrc using `g:ale_fixers`, before or
after ALE has been loaded.

A `*` in place of the filetype will apply a List of fixers to all files which
do not match some filetype in the Dictionary.

Note that using a plain List for `g:ale_fixers` is not supported.

```vim
" In ~/.vim/vimrc, or somewhere similar.
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['eslint'],
\}
```

If you want to automatically fix files when you save them, you need to turn
a setting on in vimrc.

```vim
" Set this variable to 1 to fix files when you save them.
let g:ale_fix_on_save = 1
```

The `:ALEFixSuggest` command will suggest some supported tools for fixing code.
Both `g:ale_fixers` and `b:ale_fixers` can also accept functions, including
lambda functions, as fixers, for fixing files with custom tools.

See `:help ale-fix` for complete information on how to fix files with ALE.

<a name="usage-completion"></a>

### 2.iii Completion

ALE offers some support for completion via hijacking of omnicompletion while you
type. All of ALE's completion information must come from Language Server
Protocol linters, or from `tsserver` for TypeScript.

ALE integrates with [Deoplete](https://github.com/Shougo/deoplete.nvim) as a
completion source, named `'ale'`. You can configure Deoplete to only use ALE as
the source of completion information, or mix it with other sources.

```vim
" Use ALE and also some plugin 'foobar' as completion sources for all code.
call deoplete#custom#option('sources', {
\ '_': ['ale', 'foobar'],
\})
```

ALE also offers its own automatic completion support, which does not require any
other plugins, and can be enabled by changing a setting before ALE is loaded.

```vim
" Enable completion where available.
" This setting must be set before ALE is loaded.
"
" You should not turn this setting on if you wish to use ALE as a completion
" source for other completion plugins, like Deoplete.
let g:ale_completion_enabled = 1
```

ALE provides an omni-completion function you can use for triggering
completion manually with `<C-x><C-o>`.

```vim
set omnifunc=ale#completion#OmniFunc
```

ALE supports automatic imports from external modules. This behavior is disabled
by default and can be enabled by setting:

```vim
let g:ale_completion_autoimport = 1
```

See `:help ale-completion` for more information.

<a name="usage-go-to-definition"></a>

### 2.iv Go To Definition

ALE supports jumping to the definition of words under your cursor with the
`:ALEGoToDefinition` command using any enabled Language Server Protocol linters
and `tsserver`.

See `:help ale-go-to-definition` for more information.

<a name="usage-find-references"></a>

### 2.v Find References

ALE supports finding references for words under your cursor with the
`:ALEFindReferences` command using any enabled Language Server Protocol linters
and `tsserver`.

See `:help ale-find-references` for more information.

<a name="usage-hover"></a>

### 2.vi Hovering

ALE supports "hover" information for printing brief information about symbols at
the cursor taken from Language Server Protocol linters and `tsserver` with the
`ALEHover` command.

Truncated information will be displayed when the cursor rests on a symbol by
default, as long as there are no problems on the same line.

The information can be displayed in a `balloon` tooltip in Vim or GVim by
hovering your mouse over symbols. Mouse hovering is enabled by default in GVim,
and needs to be configured for Vim 8.1+ in terminals.

See `:help ale-hover` for more information.

<a name="usage-symbol-search"></a>

### 2.vii Symbol Search

ALE supports searching for workspace symbols via Language Server Protocol
linters with the `ALESymbolSearch` command.

Search queries can be performed to find functions, types, and more which are
similar to a given query string.

See `:help ale-symbol-search` for more information.

<a name="installation"></a>

## 3. Installation

In Vim 8 and NeoVim, you can install plugins easily without needing to use
any other tools. Simply clone the plugin into your `pack` directory.

```bash
mkdir -p ~/.vim/pack/
git submodule add --name ale https://github.com/fesaille/vim-ale.git ~/.vim/pack/vim-ale
git submodule update --init --checkout --recursive
```

#### Generating Vim help files

You can add the following line to your vimrc files to generate documentation
tags automatically, if you don't have something similar already, so you can use
the `:help` command to consult ALE's online documentation:

```vim
" Put these lines at the very end of your vimrc file.

" Load all plugins now.
" Plugins need to be added to runtimepath before helptags can be generated.
packloadall
" Load all of the helptags now, after plugins have been loaded.
" All messages and errors will be ignored.
silent! helptags ALL
```

