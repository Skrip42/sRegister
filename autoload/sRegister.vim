let s:test_buffer = 0
let s:regPos = {}
let s:typPos = {}
let s:ptab = 0
let s:pbuf = 0
let s:pwin = 0
let s:buffopen = 0

let s:rLen = 0

let g:SRegisterFull = 0
let g:SRegisterWindow = 'vertical botright 40new'

function! sRegister#open()
    if s:buffopen == 1
        return
    endif
    let s:otab = tabpagenr()
    let s:obuf = bufnr('')
    let s:owin = winnr()

    let s:buffopen = 1

    execute get(g:, 'sRegisterWindow', g:SRegisterWindow)
    let s:test_buffer = bufnr('')
    setlocal nonumber buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
    let s:ptab = tabpagenr()
    let s:pbuf = bufnr('')
    let s:pwin = winnr()
    set filetype=sregister
    call s:redrow_reglist_buffer()

    noautocmd execute 'tabnext' s:otab
    noautocmd execute s:owin.'wincmd w' 
    noautocmd execute 'buf' s:obuf
endfunction

function! sRegister#close()
    if s:buffopen == 0
        return
    endif
    let s:buffopen = 0
    silent! execute 'bd' s:pbuf
    let s:pbuf = 0
endfunction

function sRegister#onClose()
    if bufnr('') != s:pbuf
        return
    endif
    let s:buffopen = 0
endfunction

function! sRegister#toggle()
    if s:buffopen == 0
        call sRegister#open()
    else
        call sRegister#close()
    endif
endfunction

function! s:regConvert(type)
    if a:type =~ 'V'
        return 'l'
    elseif a:type =~ 'v'
        return 'c'
    elseif a:type =~ ''
        return 'b'
    else 
        return 'u'
    endif
endfunction

function! s:redrow_reglist_buffer()
    let s:regPos = {}
    let s:typPos = {}
    let s:rLen = 1
    call setbufline(s:pbuf, s:rLen, "Registers")
    let s:rLen += 1
    call setbufline(s:pbuf, s:rLen, "  special:")
    let s:rLen += 1
    for r in ['"', '*', '+', '-']
        if g:SRegisterFull || strlen(getreg(r))
            let s:regPos[s:rLen] = r 
            let s:typPos[s:rLen] = s:regConvert(getregtype(r))
            call setbufline(s:pbuf, s:rLen, printf("    %s: %s %s", r, s:typPos[s:rLen], getreg(r)))
            let s:rLen += 1
        endif
    endfor
    call setbufline(s:pbuf, s:rLen, "  readonly:")
    let s:rLen += 1
    for r in ['.', ':', '%', '#', '/']
        if g:SRegisterFull || strlen(getreg(r))
            let s:regPos[s:rLen] = r 
            let s:typPos[s:rLen] = s:regConvert(getregtype(r))
            call setbufline(s:pbuf, s:rLen, printf("    %s: %s %s", r, s:typPos[s:rLen], getreg(r)))
            let s:rLen += 1
        endif
    endfor
    call setbufline(s:pbuf, s:rLen, "  numered:")
    let s:rLen += 1
    for r in map(range(0, 9), 'string(v:val)')
        if g:SRegisterFull || strlen(getreg(r))
            let s:regPos[s:rLen] = r 
            let s:typPos[s:rLen] = s:regConvert(getregtype(r))
            call setbufline(s:pbuf, s:rLen, printf("    %s: %s %s", r, s:typPos[s:rLen], getreg(r)))
            let s:rLen += 1
        endif
    endfor
    call setbufline(s:pbuf, s:rLen, "  named:")
    let s:rLen += 1
    for r in map(range(97, 97 + 25), 'nr2char(v:val)')
        if g:SRegisterFull || strlen(getreg(r))
            let s:regPos[s:rLen] = r 
            let s:typPos[s:rLen] = s:regConvert(getregtype(r))
            call setbufline(s:pbuf, s:rLen, printf("    %s: %s %s", r, s:typPos[s:rLen], getreg(r)))
            let s:rLen += 1
        endif
    endfor
    let s:rLen -= 1
endfunction

function sRegister#Update()
    if s:buffopen == 0
        return
    endif
    call s:testChange()
    call s:redrow_reglist_buffer()
endfunction

function s:testChange()
    if bufnr('') != s:pbuf
        return
    endif
    for pos in range(1, s:rLen)
        if has_key(s:regPos, pos) && index(['"', '*', '+', '-','.', ':', '%', '#', '/'], s:regPos[pos]) == -1
            let str = getline(pos)
            "let size = strlen(str) - 2
            if getreg(s:regPos[pos]) != str[9:] || s:regConvert(s:typPos[pos]) != str[7]
                call setreg(s:regPos[pos], str[9:], str[7]) 
            endif
        endif
    endfor
endfunction
