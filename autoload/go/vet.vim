" don't spam the user when Vim is started in Vi compatibility mode
let s:cpo_save = &cpo
set cpo&vim

" Vet calls 'go vet' on the current directory. Any warnings are populated in
" the location list
function! go#lint#Vet(bang, ...) abort
  call go#cmd#autowrite()

  if go#config#EchoCommandInfo()
    call go#util#EchoProgress('calling vet...')
  endif

  let l:cmd = ['go', 'vet']

  let buildtags = go#config#BuildTags()
  if buildtags isnot ''
    let cmd += ['-tags', buildtags]
  endif

  if a:0 != 0
    call extend(cmd, a:000)
  endif

  let cmd += [go#package#ImportPath()]

  let [l:out, l:err] = go#util#Exec(l:cmd)

  let l:listtype = go#list#Type("GoVet")
  if l:err != 0
    let l:winid = win_getid(winnr())
    let l:errorformat = "%-Gexit status %\\d%\\+," . &errorformat
    call go#list#ParseFormat(l:listtype, l:errorformat, out, "GoVet")
    let l:errors = go#list#Get(l:listtype)

    if empty(l:errors)
      call go#util#EchoError(l:out)
      return
    endif

    call go#list#Window(l:listtype, len(l:errors))
    if !empty(l:errors) && !a:bang
      call go#list#JumpToFirst(l:listtype)
    else
      call win_gotoid(l:winid)
    endif
  else
    call go#list#Clean(l:listtype)
    call go#util#EchoSuccess('[vet] PASS')
  endif
endfunction

" restore Vi compatibility settings
let &cpo = s:cpo_save
unlet s:cpo_save

" vim: sw=2 ts=2 et
