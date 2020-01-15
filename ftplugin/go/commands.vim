" -- mod
command! -nargs=0 -range GoModFmt call go#mod#Format()

" -- tool
command! -nargs=* -complete=customlist,go#tool#ValidFiles GoFiles echo go#tool#Files(<f-args>)
command! -nargs=0 GoDeps echo go#tool#Deps()

" -- cmd
command! -nargs=* -bang GoBuild call go#cmd#Build(<bang>0,<f-args>)
command! -nargs=? -bang GoBuildTags call go#cmd#BuildTags(<bang>0, <f-args>)
command! -nargs=* -bang GoGenerate call go#cmd#Generate(<bang>0,<f-args>)
command! -nargs=* -bang -complete=file GoRun call go#cmd#Run(<bang>0,<f-args>)
command! -nargs=* -bang GoInstall call go#cmd#Install(<bang>0, <f-args>)

" -- test
command! -nargs=* -bang GoTest call go#test#Test(<bang>0, 0, <f-args>)
command! -nargs=* -bang GoTestFunc call go#test#Func(<bang>0, <f-args>)
command! -nargs=* -bang GoTestCompile call go#test#Test(<bang>0, 1, <f-args>)

" -- cover
command! -nargs=* -bang GoCoverage call go#coverage#Buffer(<bang>0, <f-args>)
command! -nargs=* -bang GoCoverageClear call go#coverage#Clear()
command! -nargs=* -bang GoCoverageToggle call go#coverage#BufferToggle(<bang>0, <f-args>)

" -- doc
command! -nargs=* -range -complete=customlist,go#package#Complete GoDoc call go#doc#Open('new', 'split', <f-args>)

" -- fmt
command! -nargs=0 GoFmt call go#fmt#Format(-1)
command! -nargs=0 GoFmtAutoSaveToggle call go#fmt#ToggleFmtAutoSave()
command! -nargs=0 GoImports call go#fmt#Format(1)

" -- import
command! -nargs=? -complete=customlist,go#package#Complete GoDrop call go#import#SwitchImport(0, '', <f-args>, '')
command! -nargs=1 -bang -complete=customlist,go#package#Complete GoImport call go#import#SwitchImport(1, '', <f-args>, '<bang>')
command! -nargs=* -bang -complete=customlist,go#package#Complete GoImportAs call go#import#SwitchImport(1, <f-args>, '<bang>')

" -- linters
command! -nargs=* -bang GoLint call go#lint#Golint(<bang>0, <f-args>)
command! -nargs=* -bang GoVet call go#lint#Vet(<bang>0, <f-args>)

" vim: sw=2 ts=2 et
