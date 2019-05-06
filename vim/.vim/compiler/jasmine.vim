if exists('jasmine')
  finish
endif
let current_compiler = 'jasmine'

set makeprg=ng

" The whitespace in the last column is important
set errorformat=%E%trror\ in\ [%.%#]\ ./%f:%l:%c\ 
set errorformat+=%E%\\s%\\+Type%trror:\ %m\ in\ src/test.ts\ (line\ %.%#)
set errorformat+=%-C%\\s%\\+%.%#/node_modules/%.%#
set errorformat+=%C%\\s%\\+webpack:///%f:%l:%c\ <-\ src/test.ts:%.%#
set errorformat+=%-C%\\s%\\+%.%#src/test.ts%.%#
set errorformat+=%Z%.%#TS%.%#:\ %m
