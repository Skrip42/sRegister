augroup sRegister
    autocmd!
    autocmd BufUnload * :call sRegister#onClose()
    autocmd CursorHold * :call sRegister#Update()
augroup END

command! SRegisterClose  call sRegister#close()
command! SRegisterOpend  call sRegister#open()
command! SRegisterToggle call sRegister#toggle()
