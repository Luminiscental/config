
" Clear language syntax
syn keyword clrKeywords val var print if else and or return func while struct void this nil

syn keyword clrBuiltins str num int bool clock

syn match clrIdent '[a-zA-Z_][a-zA-Z0-9_]*'

syn match clrNumber '\d\+\(\.\d\+\)\?'

syn match clrInteger '\d\+i'

syn match clrBoolean 'true\|false'

syn region clrString start="\"" end="\""

syn match clrComment '//.*'

syn match clrSymbol '[?\.,<>{}()!+=\*\-;:/]\(/\)\@!'

