
" Clear language syntax
syn keyword clrKeywords val var print if else and or return func while struct

syn keyword clrBuiltins type str num int bool 

syn match clrIdent '[a-zA-Z_][a-zA-Z0-9_]*'

syn match clrNumber '\d\+\(\.\d\+\)\?'

syn match clrInteger '\d\+i'

syn match clrBoolean 'true\|false'

syn region clrString start="\"" end="\""

syn match clrComment '//.*'

syn match clrSymbol '[,<>{}()!+=\*\-;/]\(/\)\@!'

