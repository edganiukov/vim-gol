" don't spam the user when Vim is started in Vi compatibility mode
let s:cpo_save = &cpo
set cpo&vim

function! go#cmd#autowrite() abort
  if &autowrite == 1 || &autowriteall == 1
    silent! wall
  else
    for l:nr in range(0, bufnr('$'))
      if buflisted(l:nr) && getbufvar(l:nr, '&modified')
        " Sleep one second to make sure people see the message. Otherwise it is
        " often immediately overwritten by the async messages (which also
        " doesn't invoke the "hit ENTER" prompt).
        call go#util#EchoWarning('[No write since last change]')
        sleep 1
        return
      endif
    endfor
  endif
endfunction

" Build builds the source code without producing any output binary. We live in
" an editor so the best is to build it to catch errors and fix them. By
" default it tries to call simply 'go build', but it first tries to get all
" dependent files for the current folder and passes it to go build.
function! go#cmd#Build(bang, ...) abort
  " Create our command arguments. go build discards any results when it
  " compiles multiple packages. So we pass the `errors` package just as an
  " placeholder with the current folder (indicated with '.').
  let l:args =
        \ ['build', '-tags', go#config#BuildTags()] +
        \ map(copy(a:000), "expand(v:val)") +
        \ [".", "errors"]

  " Vim and Neovim async
  if go#util#has_job()
    call s:cmd_job({
          \ 'cmd': ['go'] + args,
          \ 'bang': a:bang,
          \ 'for': 'GoBuild',
          \ 'statustype': 'build'
          \})

  " Vim without async
  else
    let l:status = {
          \ 'desc': 'current status',
          \ 'type': 'build',
          \ 'state': "started",
          \ }
    call go#statusline#Update(expand('%:p:h'), l:status)

    let default_makeprg = &makeprg
    let &makeprg = "go " . join(go#util#Shelllist(args), ' ')

    let l:listtype = go#list#Type("GoBuild")
    " execute make inside the source folder so we can parse the errors
    " correctly
    let cd = exists('*haslocaldir') && haslocaldir() ? 'lcd ' : 'cd '
    let dir = getcwd()
    try
      execute cd . fnameescape(expand("%:p:h"))
      if l:listtype == "locationlist"
        silent! exe 'lmake!'
      else
        silent! exe 'make!'
      endif
      redraw!
    finally
      execute cd . fnameescape(dir)
      let &makeprg = default_makeprg
    endtry

    let errors = go#list#Get(l:listtype)
    call go#list#Window(l:listtype, len(errors))
    if !empty(errors) && !a:bang
      call go#list#JumpToFirst(l:listtype)
      let l:status.state = 'failed'
    else
      let l:status.state = 'success'
      if go#config#EchoCommandInfo()
        call go#util#EchoSuccess("[build] SUCCESS")
      endif
    endif
    call go#statusline#Update(expand('%:p:h'), l:status)
  endif

endfunction

" BuildTags sets or shows the current build tags used for tools
function! go#cmd#BuildTags(bang, ...) abort
  if a:0
    let v = a:1
    if v == '""' || v == "''"
      let v = ""
    endif
    call go#config#SetBuildTags(v)
    let tags = go#config#BuildTags()
    if empty(tags)
      call go#util#EchoSuccess("build tags are cleared")
    else
      call go#util#EchoSuccess("build tags are changed to: " . tags)
    endif

    return
  endif

  let tags = go#config#BuildTags()
  if empty(tags)
    call go#util#EchoSuccess("build tags are not set")
  else
    call go#util#EchoSuccess("current build tags: " . tags)
  endif
endfunction


" Run runs the current file (and their dependencies if any) in a new terminal.
function! go#cmd#RunTerm(bang, mode, files) abort
  let cmd = "go run "
  let tags = go#config#BuildTags()
  if len(tags) > 0
    let cmd .= "-tags " . go#util#Shellescape(tags) . " "
  endif

  if empty(a:files)
    let cmd .= go#util#Shelljoin(go#tool#Files())
  else
    let cmd .= go#util#Shelljoin(map(copy(a:files), "expand(v:val)"), 1)
  endif
  call go#term#newmode(a:bang, cmd, s:runerrorformat(), a:mode)
endfunction

" Run runs the current file (and their dependencies if any) and outputs it.
" This is intended to test small programs and play with them. It's not
" suitable for long running apps, because vim is blocking by default and
" calling long running apps will block the whole UI.
function! go#cmd#Run(bang, ...) abort
  if has('nvim')
    call go#cmd#RunTerm(a:bang, '', a:000)
    return
  endif

  if go#util#has_job()
    " NOTE(arslan): 'term': 'open' case is not implement for +jobs. This means
    " executions waiting for stdin will not work. That's why we don't do
    " anything. Once this is implemented we're going to make :GoRun async
  endif

  let l:status = {
        \ 'desc': 'current status',
        \ 'type': 'run',
        \ 'state': "started",
        \ }

  call go#statusline#Update(expand('%:p:h'), l:status)

  let cmd = "go run "
  let tags = go#config#BuildTags()
  if len(tags) > 0
    let cmd .= "-tags " . go#util#Shellescape(tags) . " "
  endif

  if go#util#IsWin()
    if a:0 == 0
      exec '!' . cmd . go#util#Shelljoin(go#tool#Files(), 1)
    else
      exec '!' . cmd . go#util#Shelljoin(map(copy(a:000), "expand(v:val)"), 1)
    endif

    let l:status.state = 'success'
    if v:shell_error
      let l:status.state = 'failed'
      if go#config#EchoCommandInfo()
        redraws!
        call go#util#EchoError('[run] FAILED')
      endif
    else
      if go#config#EchoCommandInfo()
        redraws!
        call go#util#EchoSuccess('[run] SUCCESS')
      endif
    endif

    call go#statusline#Update(expand('%:p:h'), l:status)
    return
  endif

  " :make expands '%' and '#' wildcards, so they must also be escaped
  let default_makeprg = &makeprg
  if a:0 == 0
    let &makeprg = cmd . go#util#Shelljoin(go#tool#Files(), 1)
  else
    let &makeprg = cmd . go#util#Shelljoin(map(copy(a:000), "expand(v:val)"), 1)
  endif

  let l:listtype = go#list#Type("GoRun")

  let l:status.state = 'success'
  try
    " backup user's errorformat, will be restored once we are finished
    let l:old_errorformat = &errorformat
    let &errorformat = s:runerrorformat()
    if l:listtype == "locationlist"
      exe 'lmake!'
    else
      exe 'make!'
    endif
  finally
    "restore errorformat
    let &errorformat = l:old_errorformat
    let &makeprg = default_makeprg
  endtry

  let l:errors = go#list#Get(l:listtype)

  call go#list#Window(l:listtype, len(l:errors))
  if !empty(l:errors)
    let l:status.state = 'failed'
    if !a:bang
      call go#list#JumpToFirst(l:listtype)
    endif
  endif
  call go#statusline#Update(expand('%:p:h'), l:status)
endfunction

function! s:runerrorformat()
  let l:panicaddress = "%\\t%#%f:%l +0x%[0-9A-Fa-f]%\\+"
  let l:errorformat = '%A' . l:panicaddress . "," . &errorformat
  return l:errorformat
endfunction

" ---------------------
" | Vim job callbacks |
" ---------------------

function! s:cmd_job(args) abort
  " autowrite is not enabled for jobs
  call go#cmd#autowrite()

  call go#job#Spawn(a:args.cmd, a:args)
endfunction

" restore Vi compatibility settings
let &cpo = s:cpo_save
unlet s:cpo_save

" vim: sw=2 ts=2 et
