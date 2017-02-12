" ----------------------------------------
" global variable
" ----------------------------------------
let pluginBaseDir=expand("~/dotfiles/editors/vim/plugins")
let deinRepo="https://github.com/Shougo/dein.vim"
let deinDir=expand(pluginBaseDir . "/dein.vim")

" ----------------------------------------
" main
" ----------------------------------------
if !isdirectory(deinDir)
  execute "!git clone " . deinRepo . " " . deinDir
endif

if &compatible
  set nocompatible
endif
execute 'set runtimepath+=' . deinDir

if dein#load_state(pluginBaseDir)
  call dein#begin(pluginBaseDir)
  call dein#add(deinDir)

  " util
  call dein#add('altercation/vim-colors-solarized')
  call dein#add('Shougo/deoplete.nvim')
  call dein#add('Shougo/neosnippet')
  call dein#add('Shougo/neosnippet-snippets')
  call dein#add('Shougo/vimshell')
  call dein#add('Shougo/unite.vim')
  call dein#add('Shougo/neomru.vim')
  call dein#add('scrooloose/nerdtree')
  call dein#add('scrooloose/nerdcommenter')
  call dein#add('neomake/neomake')
  call dein#add('jistr/vim-nerdtree-tabs')
  call dein#add('tpope/vim-surround')
  call dein#add('tpope/vim-fugitive')
  call dein#add('bling/vim-airline')
  call dein#add('godlygeek/tabular')
  call dein#add('easymotion/vim-easymotion')
  call dein#add('majutsushi/tagbar')
  call dein#add('ervandew/supertab')
  call dein#add('honza/vim-snippets')
  call dein#add('jiangmiao/auto-pairs')
  call dein#add('rking/ag.vim')
  call dein#add('Yggdroot/indentLine')
  call dein#add('terryma/vim-multiple-cursors')
  call dein#add('yggdroot/indentline')
  call dein#add('google/vim-maktaba')
  call dein#add('google/vim-codefmt')
  call dein#add('google/vim-glaive')

  " JSON
  call dein#add('elzr/vim-json')

  " html
  call dein#add('othree/html5.vim')

  " javascript
  call dein#add('pangloss/vim-javascript')
  call dein#add('jelera/vim-javascript-syntax')
  call dein#add('moll/vim-node')
  call dein#add('othree/javascript-libraries-syntax.vim')

  " golang
  call dein#add('fatih/vim-go')
  call dein#add('dgryski/vim-godef')

  " ruby
  call dein#add('vim-ruby/vim-ruby')

  " python
  call dein#add('hdima/python-syntax')

  call dein#end()
  call dein#save_state()
endif

" Required:
syntax enable
filetype plugin indent on

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

