" don't spam the user when Vim is started in Vi compatibility mode
let s:cpo_save = &cpo
set cpo&vim

function! go#auto#modfmt_autosave()
  if !(go#config#ModFmtAutosave() && isdirectory(expand('%:p:h')) && expand('<afile>:p') == expand('%:p'))
    return
  endif

  " go.mod code formatting on save
  call go#mod#Format()
endfunction

" restore Vi compatibility settings
let &cpo = s:cpo_save
unlet s:cpo_save

" vim: sw=2 ts=2 et
