augroup sRegister
    autocmd!
    autocmd BufUnload * :call sRegister#onClose()
    autocmd CursorHold * :call sRegister#Update()
augroup END
