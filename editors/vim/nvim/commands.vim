" ----------------------------------------
" command
" ----------------------------------------
" vimrc read/write
command! Ev edit $MYVIMRC
command! Rv source $MYVIMRC

" count string in file
command! -nargs=0 Wc %s/.//nge