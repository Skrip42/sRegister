echom "syntax loaded"
syntax clear
syntax match sRegisterTitle /^Registers/
syntax match sRegisterSubTitle /^  [a-z]*\:/
"syntax region sRegisterType start=/^/ end=/$/
"syntax match sRegisterType /\(?<=    .\: \)[lcbu]/
syntax match sRegisterRegister /^    .\:/ contained
syntax match sRegisterType /^    .\: [lcbu]/ contains=sRegisterRegister
highlight default link sRegisterTitle Title
highlight default link sRegisterSubTitle Identifier 
highlight default link sRegisterType Type 
highlight default link sRegisterRegister Label 
