if exists("g:go_run_plugin")
  finish
endif
let g:go_run_plugin = 1

" don't spam the user when Vim is started in Vi compatibility mode
let s:cpo_save = &cpo
set cpo&vim

function! s:checkVersion() abort
  let l:unsupported = 0
  if go#config#VersionWarning() != 0
    if has('nvim')
      let l:unsupported = !has('nvim-0.3.2')
    else
      let l:unsupported = !has('patch-8.0.1453')
    endif

    if l:unsupported == 1
      echohl Error
      echom "vim-gol requires at least Vim 8.0.1453 or Neovim 0.3.2, but you're using an older version."
      echom "Please update your Vim for the best vim-go experience."
      echom "If you really want to continue you can set this to make the error go away:"
      echom "    let g:go_version_warning = 0"
      echom "Note that some features may error out or behave incorrectly."
      echom "Please do not report bugs unless you're using at least Vim 8.0.1453 or Neovim 0.3.2."
      echohl None

      " Make sure people see this.
      sleep 2
    endif
  endif
endfunction

call s:checkVersion()

fun! s:complete(lead, cmdline, cursor)
  return filter(keys(s:packages), 'strpart(v:val, 0, len(a:lead)) == a:lead')
endfun


" Autocommands
" ============================================================================
"
" We take care to preserve the user's fileencodings and fileformats,
" because those settings are global (not buffer local), yet we want
" to override them for loading Go files, which are defined to be UTF-8.
let s:current_fileformats = ''
let s:current_fileencodings = ''

" define fileencodings to open as utf-8 encoding even if it's ascii.
function! s:gofiletype_pre()
  let s:current_fileformats = &g:fileformats
  let s:current_fileencodings = &g:fileencodings
  set fileencodings=utf-8 fileformats=unix
endfunction

" restore fileencodings as others
function! s:gofiletype_post()
  let &g:fileformats = s:current_fileformats
  let &g:fileencodings = s:current_fileencodings
endfunction

function! s:register()
  if !(&modifiable && expand('<amatch>') ==# 'go')
    return
  endif
endfunction

function! s:noop(...) abort
endfunction

augroup vim-go
  autocmd!

  autocmd BufNewFile *.go if &modifiable | setlocal fileencoding=utf-8 fileformat=unix | endif
  autocmd BufRead *.go call s:gofiletype_pre()
  autocmd BufReadPost *.go call s:gofiletype_post()

  autocmd BufNewFile *.s if &modifiable | setlocal fileencoding=utf-8 fileformat=unix | endif
  autocmd BufRead *.s call s:gofiletype_pre()
  autocmd BufReadPost *.s call s:gofiletype_post()

  if go#util#has_job()
    autocmd FileType * call s:register()
  endif
augroup end

" restore Vi compatibility settings
let &cpo = s:cpo_save
unlet s:cpo_save

" vim: sw=2 ts=2 et
