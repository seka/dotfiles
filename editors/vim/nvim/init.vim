" ----------------------------------------
" basic
" ----------------------------------------
" encoding
set encoding=utf-8
set termencoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,cp932,euc-jp

" silent
set novisualbell

" show line number
set number

" line
set cursorline

" clipboard
set clipboard+=unnamedplus

" remove space when save
autocmd BufWritePre * :%s/\s\+$//e

" (), {} hilight
set showmatch

" swap, backup
set directory=~/dotfiles/editors/vim/swaps
set backupdir=~/dotfiles/editors/vim/backups

" ----------------------------------------
" load plugin
" ----------------------------------------
runtime! ./install-plugins.vim

" ----------------------------------------
" Color
" ----------------------------------------
let g:solarized_termcolors=256
set background=dark
colorscheme solarized
hi Comment ctermfg=2

" ----------------------------------------
" Original command
" ----------------------------------------
runtime! commands.vim

