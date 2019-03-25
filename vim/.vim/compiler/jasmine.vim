if exists('jasmine')
  finish
endif
let current_compiler = 'jasmine'

set makeprg=ng
set errorformat=%E\ \ %.%#Error:%m,%-G%.%#/jasmine.js:%.%#,%C\ %#at\ %.%#\ (%f:%l:%c)
