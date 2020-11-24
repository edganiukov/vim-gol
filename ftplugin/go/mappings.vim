" go_jump_to_error defines whether we should pass the bang attribute to the
" command or not. This is only used for mappings, because the user can't pass
" the bang attribute to the plug mappings below. So instead of hardcoding it
" as 0 (no '!' attribute) or 1 (with '!' attribute) we pass the user setting,
" which by default is enabled. For commands the user has the ability to pass
" the '!', such as :GoBuild or :GoBuild!
if !exists("g:go_jump_to_error")
  let g:go_jump_to_error = 1
endif

" Some handy plug mappings
nnoremap <silent> <Plug>(go-run) :<C-u>call go#cmd#Run(!g:go_jump_to_error)<CR>

if has("nvim")
  nnoremap <silent> <Plug>(go-run-vertical) :<C-u>call go#cmd#RunTerm(!g:go_jump_to_error, 'vsplit', [])<CR>
  nnoremap <silent> <Plug>(go-run-split) :<C-u>call go#cmd#RunTerm(!g:go_jump_to_error, 'split', [])<CR>
  nnoremap <silent> <Plug>(go-run-tab) :<C-u>call go#cmd#RunTerm(!g:go_jump_to_error, 'tabe', [])<CR>
endif

nnoremap <silent> <Plug>(go-build) :<C-u>call go#cmd#Build(!g:go_jump_to_error)<CR>
nnoremap <silent> <Plug>(go-generate) :<C-u>call go#cmd#Generate(!g:go_jump_to_error)<CR>
nnoremap <silent> <Plug>(go-install) :<C-u>call go#cmd#Install(!g:go_jump_to_error)<CR>
nnoremap <silent> <Plug>(go-test) :<C-u>call go#test#Test(!g:go_jump_to_error, 0)<CR>
nnoremap <silent> <Plug>(go-test-func) :<C-u>call go#test#Func(!g:go_jump_to_error)<CR>
nnoremap <silent> <Plug>(go-test-compile) :<C-u>call go#test#Test(!g:go_jump_to_error, 1)<CR>

nnoremap <silent> <Plug>(go-coverage) :<C-u>call go#coverage#Buffer(!g:go_jump_to_error)<CR>
nnoremap <silent> <Plug>(go-coverage-clear) :<C-u>call go#coverage#Clear()<CR>
nnoremap <silent> <Plug>(go-coverage-toggle) :<C-u>call go#coverage#BufferToggle(!g:go_jump_to_error)<CR>


" vim: sw=2 ts=2 et
