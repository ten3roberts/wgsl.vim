if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

setlocal autoindent
setlocal nolisp
setlocal indentexpr=WgslIndent(v:lnum)

" Only define the function once.
if exists("*WgslIndent")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

function! WgslIndent(lnum)
  if a:lnum == 1
    return 0
  endif


  let prev = a:lnum - 1
  while prev > 1 && getline(prev) == ""
    let prev -= 1
  endwhile

  let l:prev_line = getline(l:prev)
  let l:indent = indent(prev)
  let l:line = getline(a:lnum)

  " Ending with {, (, or [
  let open = l:prev_line =~# '^[^/]*\({\|(\|[\)\s*$'
  let close = l:line =~# '^\s*\(}\|)\|]\)'
  if open && close
    return l:indent
  endif

  if open
    return l:indent + &shiftwidth
  endif

  " Ending with }
  if close
    return l:indent - &shiftwidth
  endif


  return l:indent
endfunc

let &cpo = s:cpo_save
unlet s:cpo_save
