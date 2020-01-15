command! -nargs=0 -range GoModFmt call go#mod#Format()

command! -nargs=0 GoModFmtAutoSaveToggle call go#mod#ToggleModFmtAutoSave()

" vim: sw=2 ts=2 et
