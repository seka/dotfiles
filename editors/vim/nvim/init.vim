" ----------------------------------------
" basic
" ----------------------------------------
" encoding
set encoding=utf-8
" set termencoding=utf-8  " Not supported in Neovim
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

" tab
set tabstop=2
set shiftwidth=2
set expandtab

" swap, backup
set directory=~/dotfiles/editors/vim/swaps
set backupdir=~/dotfiles/editors/vim/backups

" ----------------------------------------
" load plugin
" ----------------------------------------
runtime! ./install-plugins.vim

" ----------------------------------------
" Plugin settings / LSP（初回取得後の再起動から読み込む）
" ----------------------------------------
if get(g:, 'dotfiles_plugins_ready', 0)
  runtime! setting-plugins.vim

  lua require('lsp_config')
endif

" ----------------------------------------
" Git Mergetool Enhancement
" ----------------------------------------
" diffモード時にmergetool専用設定を読み込み
if &diff
  runtime! mergetool.vim
endif

" ----------------------------------------
" Original command
" ----------------------------------------
runtime! commands.vim
