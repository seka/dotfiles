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
  call dein#add('vim-denops/denops.vim')
  call dein#add('Shougo/ddc.vim')
  call dein#add('Shougo/ddc-ui-pum')
  call dein#add('Shougo/pum.vim')
  call dein#add('Shougo/ddc-source-lsp')
  call dein#add('Shougo/ddc-source-around')
  call dein#add('Shougo/ddc-filter-matcher_head')
  call dein#add('Shougo/ddc-filter-sorter_rank')
  call dein#add('Shougo/neosnippet')
  call dein#add('Shougo/neosnippet-snippets')
  call dein#add('akinsho/toggleterm.nvim')
  call dein#add('nvim-lua/plenary.nvim')
  call dein#add('nvim-telescope/telescope.nvim')
  call dein#add('Shougo/neomru.vim')
  call dein#add('scrooloose/nerdtree')
  call dein#add('scrooloose/nerdcommenter')
  call dein#add('jistr/vim-nerdtree-tabs')
  call dein#add('akinsho/bufferline.nvim')
  call dein#add('nvim-tree/nvim-web-devicons')
  call dein#add('mfussenegger/nvim-lint')
  call dein#add('stevearc/conform.nvim')
  call dein#add('tpope/vim-surround')
  call dein#add('tpope/vim-fugitive')
  call dein#add('nvim-lualine/lualine.nvim')
  call dein#add('godlygeek/tabular')
  call dein#add('easymotion/vim-easymotion')
  call dein#add('majutsushi/tagbar')
  call dein#add('jiangmiao/auto-pairs')
  call dein#add('Yggdroot/indentLine')
  call dein#add('terryma/vim-multiple-cursors')
  call dein#add('editorconfig/editorconfig-vim')

  " LSP
  call dein#add('williamboman/mason.nvim')
  call dein#add('williamboman/mason-lspconfig.nvim')
  call dein#add('neovim/nvim-lspconfig')

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

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

