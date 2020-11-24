# vim-gol
A lightweight vim plugin for Go

It is a fork of [vim-go](https://github.com/fatih/vim-go) with removed all unnecessary functionality (that I don't use or possible to replace with [vim-lsp](https://github.com/prabirshrestha/vim-lsp)).

## Features
* Compile your package with `:GoBuild`, install it with `:GoInstall`.
* Test it with `:GoTest`, run a single test with `:GoTestFunc`.
* Quickly execute your current file(s) with `:GoRun`.
* Improved syntax highlighting and folding.
* See which code is covered by tests with `:GoCoverage`.
* Most commands are run asynchronous in Neovim and Vim 8. Fully async building and testing.
* Integrated with the Neovim terminal, launch `:GoRun` and other Go commands in a terminal buffer.
* Supports integration with the Tagbar plugin.

## Dependencies
* [go](https://github.com/golang/go)
* [gotags](https://github.com/jstemmer/gotags)
