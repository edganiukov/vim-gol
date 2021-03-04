" don't spam the user when Vim is started in Vi compatibility mode
let s:cpo_save = &cpo
set cpo&vim

function! go#config#ListTypeCommands() abort
  return get(g:, 'go_list_type_commands', {})
endfunction

function! go#config#VersionWarning() abort
  return get(g:, 'go_version_warning', 1)
endfunction

function! go#config#BuildTags() abort
  return get(g:, 'go_build_tags', '')
endfunction

function! go#config#SetBuildTags(value) abort
  if a:value is ''
    silent! unlet g:go_build_tags
    call go#lsp#ResetWorkspaceDirectories()
    return
  endif

  let g:go_build_tags = a:value
  call go#lsp#ResetWorkspaceDirectories()
endfunction

function! go#config#TestTimeout() abort
 return get(g:, 'go_test_timeout', '10s')
endfunction

function! go#config#TestShowName() abort
  return get(g:, 'go_test_show_name', 0)
endfunction

function! go#config#TermHeight() abort
  return get(g:, 'go_term_height', winheight(0))
endfunction

function! go#config#TermWidth() abort
  return get(g:, 'go_term_width', winwidth(0))
endfunction

function! go#config#TermMode() abort
  return get(g:, 'go_term_mode', 'vsplit')
endfunction

function! go#config#TermCloseOnExit() abort
  return get(g:, 'go_term_close_on_exit', 1)
endfunction

function! go#config#SetTermCloseOnExit(value) abort
  let g:go_term_close_on_exit = a:value
endfunction

function! go#config#TermEnabled() abort
  return has('nvim') && get(g:, 'go_term_enabled', 0)
endfunction

function! go#config#SetTermEnabled(value) abort
  let g:go_term_enabled = a:value
endfunction

function! go#config#StatuslineDuration() abort
  return get(g:, 'go_statusline_duration', 60000)
endfunction

function! go#config#ListType() abort
  return get(g:, 'go_list_type', '')
endfunction

function! go#config#ListAutoclose() abort
  return get(g:, 'go_list_autoclose', 1)
endfunction

function! go#config#EchoCommandInfo() abort
  return get(g:, 'go_echo_command_info', 1)
endfunction

function! go#config#Debug() abort
  return get(g:, 'go_debug', [])
endfunction

function! go#config#ListHeight() abort
  return get(g:, "go_list_height", 0)
endfunction

function! go#config#ModFmtAutosave() abort
	return get(g:, "go_mod_fmt_autosave", 1)
endfunction

function! go#config#SetModFmtAutosave(value) abort
  let g:go_mod_fmt_autosave = a:value
endfunction

function! go#config#HighlightArrayWhitespaceError() abort
  return get(g:, 'go_highlight_array_whitespace_error', 0)
endfunction

function! go#config#HighlightChanWhitespaceError() abort
  return get(g:, 'go_highlight_chan_whitespace_error', 0)
endfunction

function! go#config#HighlightExtraTypes() abort
  return get(g:, 'go_highlight_extra_types', 0)
endfunction

function! go#config#HighlightSpaceTabError() abort
  return get(g:, 'go_highlight_space_tab_error', 0)
endfunction

function! go#config#HighlightTrailingWhitespaceError() abort
  return get(g:, 'go_highlight_trailing_whitespace_error', 0)
endfunction

function! go#config#HighlightOperators() abort
  return get(g:, 'go_highlight_operators', 0)
endfunction

function! go#config#HighlightFunctions() abort
  return get(g:, 'go_highlight_functions', 0)
endfunction

function! go#config#HighlightFunctionParameters() abort
  " fallback to highlight_function_arguments for backwards compatibility
  return get(g:, 'go_highlight_function_parameters', get(g:, 'go_highlight_function_arguments', 0))
endfunction

function! go#config#HighlightFunctionCalls() abort
  return get(g:, 'go_highlight_function_calls', 0)
endfunction

function! go#config#HighlightFields() abort
  return get(g:, 'go_highlight_fields', 0)
endfunction

function! go#config#HighlightTypes() abort
  return get(g:, 'go_highlight_types', 0)
endfunction

function! go#config#HighlightBuildConstraints() abort
  return get(g:, 'go_highlight_build_constraints', 0)
endfunction

function! go#config#HighlightStringSpellcheck() abort
  return get(g:, 'go_highlight_string_spellcheck', 1)
endfunction

function! go#config#HighlightFormatStrings() abort
  return get(g:, 'go_highlight_format_strings', 1)
endfunction

function! go#config#HighlightGenerateTags() abort
  return get(g:, 'go_highlight_generate_tags', 0)
endfunction

function! go#config#HighlightVariableAssignments() abort
  return get(g:, 'go_highlight_variable_assignments', 0)
endfunction

function! go#config#HighlightVariableDeclarations() abort
  return get(g:, 'go_highlight_variable_declarations', 0)
endfunction

function! go#config#FoldEnable(...) abort
  if a:0 > 0
    return index(go#config#FoldEnable(), a:1) > -1
  endif
  return get(g:, 'go_fold_enable', ['block', 'import', 'varconst', 'package_comment'])
endfunction

function! go#config#Updatetime() abort
  let go_updatetime = get(g:, 'go_updatetime', 800)
  return go_updatetime == 0 ? &updatetime : go_updatetime
endfunction

" restore Vi compatibility settings
let &cpo = s:cpo_save
unlet s:cpo_save

" vim: sw=2 ts=2 et
