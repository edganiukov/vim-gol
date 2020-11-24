" Copyright 2013 The Go Authors. All rights reserved.
" Use of this source code is governed by a BSD-style
" license that can be found in the LICENSE file.
"
" go.vim: Vim filetype plugin for Go.

if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

" don't spam the user when Vim is started in Vi compatibility mode
let s:cpo_save = &cpo
set cpo&vim

let b:undo_ftplugin = "setl fo< com< cms<"
      \ . "| exe 'au! vim-go-buffer * <buffer>'"

setlocal formatoptions-=t

setlocal comments=s1:/*,mb:*,ex:*/,://
setlocal commentstring=//\ %s

setlocal noexpandtab

compiler go

nnoremap <buffer> <silent> gb :GoBuild<cr>
nnoremap <buffer> <silent> gt :GoTest<cr>
nnoremap <buffer> <silent> gc :GoCoverageToggle<cr>

" restore Vi compatibility settings
let &cpo = s:cpo_save
unlet s:cpo_save

" vim: sw=2 ts=2 et
