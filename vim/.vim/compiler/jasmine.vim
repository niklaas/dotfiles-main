if exists('jasmine')
  finish
endif
let current_compiler = 'jasmine'

set makeprg=ng

" The whitespace in the last column is important
set errorformat=%EERROR\ in\ %.%#\ ./%f:%l:%c\ 
set errorformat+=%Z%.%#:\ %m
