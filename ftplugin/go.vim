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
nnoremap <buffer> <silent> <leader>gd :GoDoc<cr>

if get(g:, "go_textobj_enabled", 1)
  onoremap <buffer> <silent> af :<c-u>call go#textobj#Function('a')<cr>
  xnoremap <buffer> <silent> af :<c-u>call go#textobj#Function('a')<cr>

  onoremap <buffer> <silent> if :<c-u>call go#textobj#Function('i')<cr>
  xnoremap <buffer> <silent> if :<c-u>call go#textobj#Function('i')<cr>

  onoremap <buffer> <silent> ac :<c-u>call go#textobj#Comment('a')<cr>
  xnoremap <buffer> <silent> ac :<c-u>call go#textobj#Comment('a')<cr>

  onoremap <buffer> <silent> ic :<c-u>call go#textobj#Comment('i')<cr>
  xnoremap <buffer> <silent> ic :<c-u>call go#textobj#Comment('i')<cr>

  " Remap ]] and [[ to jump betweeen functions as they are useless in Go
  nnoremap <buffer> <silent> ]] :<c-u>call go#textobj#FunctionJump('n', 'next')<cr>
  nnoremap <buffer> <silent> [[ :<c-u>call go#textobj#FunctionJump('n', 'prev')<cr>

  onoremap <buffer> <silent> ]] :<c-u>call go#textobj#FunctionJump('o', 'next')<cr>
  onoremap <buffer> <silent> [[ :<c-u>call go#textobj#FunctionJump('o', 'prev')<cr>

  xnoremap <buffer> <silent> ]] :<c-u>call go#textobj#FunctionJump('v', 'next')<cr>
  xnoremap <buffer> <silent> [[ :<c-u>call go#textobj#FunctionJump('v', 'prev')<cr>
endif

" Autocommands
" ============================================================================
"
augroup vim-go-buffer
  autocmd! * <buffer>
  autocmd BufWritePre <buffer> call go#auto#fmt_autosave()

  autocmd BufEnter <buffer>
        \  if go#config#AutodetectGopath() && !exists('b:old_gopath')
        \|   let b:old_gopath = exists('$GOPATH') ? $GOPATH : -1
        \|   let $GOPATH = go#path#Detect()
        \| endif
  autocmd BufLeave <buffer>
        \  if exists('b:old_gopath')
        \|   if b:old_gopath isnot -1
        \|     let $GOPATH = b:old_gopath
        \|   endif
        \|   unlet b:old_gopath
        \| endif
augroup end

" restore Vi compatibility settings
let &cpo = s:cpo_save
unlet s:cpo_save

" vim: sw=2 ts=2 et
