echom "syntax loaded"
syntax clear
syntax match sRegisterTitle /^Registers/
syntax match sRegisterSubTitle /^  [a-z]*:/
syntax match sRegisterRegister /^    .:/ contained
syntax match sRegisterType /^    .: [lcbu]/ contains=sRegisterRegister
highlight default link sRegisterTitle Title
highlight default link sRegisterSubTitle Identifier 
highlight default link sRegisterType Type 
highlight default link sRegisterRegister Label 
