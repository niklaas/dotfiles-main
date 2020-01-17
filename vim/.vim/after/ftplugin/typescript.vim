setlocal include=from
setlocal suffixesadd=.ts
setlocal define=class\\s

" By default <C-x><C-f> completes relative to the current working directory.
" Since TypeScript files should use relative imports, the following hack is
" applied.
augroup ft_typescript_relative_imports
  au!
  autocmd InsertEnter <buffer> let save_cwd = getcwd() | setlocal autochdir
  autocmd InsertLeave <buffer> setlocal noautochdir | execute 'cd' fnameescape(save_cwd)
augroup END

UltiSnipsAddFiletypes javascript-jasmine-arrow
