if exists('did_load_filetypes')
  finish
endif

augroup filetypedetect
  au BufNewFile,BufRead justfile setfiletype make
augroup END
