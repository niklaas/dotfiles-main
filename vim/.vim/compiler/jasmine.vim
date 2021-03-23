if exists('current_compiler')
  finish
endif
let current_compiler = 'jasmine'

CompilerSet makeprg=ng

CompilerSet errorformat=Chrome\ %.%#%\\d)\ %m\ FAILED
