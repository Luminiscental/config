
" Clear language syntax
syn keyword clrKeywords val var print if else and or

syn keyword clrBuiltins type str num int bool

syn match clrNumber '\d\+\(\.\d\+\)\?'

syn match clrInteger '\d\+i'

syn match clrBoolean 'true\|false'

syn region clrString start="\"" end="\""

syn match clrComment '//.*'

syn match clrSymbol '[{}()!+=\*\-;/]\(/\)\@!'

