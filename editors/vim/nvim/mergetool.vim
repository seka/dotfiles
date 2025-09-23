" ----------------------------------------
" Git Mergetool Configuration for Enhanced Visibility
" ----------------------------------------

" mergetool用の色設定を改善
if &diff
  " diffモード専用のカラースキーム設定
  colorscheme desert

  " diffハイライトの改善
  highlight DiffAdd    ctermbg=22 ctermfg=white guibg=#005f00 guifg=white
  highlight DiffDelete ctermbg=52 ctermfg=white guibg=#5f0000 guifg=white
  highlight DiffChange ctermbg=17 ctermfg=white guibg=#00005f guifg=white
  highlight DiffText   ctermbg=53 ctermfg=white guibg=#5f005f guifg=white

  " カーソルライン表示を有効化（現在の変更箇所を見やすく）
  set cursorline
  highlight CursorLine ctermbg=235 guibg=#262626

  " 行番号を表示
  set number

  " 文字の折り返しを無効化（横スクロールで長い行を確認）
  set nowrap

  " より見やすいfoldcolumn設定
  set foldcolumn=1

  " mergetool専用キーマップ
  " ]c - 次のdiffに移動
  " [c - 前のdiffに移動
  " do - 相手側の変更を取得
  " dp - 自分の変更を相手側に送信
  " :diffget LO - LOCALから取得
  " :diffget RE - REMOTEから取得

  " 便利なキーマップを追加
  nnoremap <leader>1 :diffget LOCAL<CR>
  nnoremap <leader>2 :diffget BASE<CR>
  nnoremap <leader>3 :diffget REMOTE<CR>

  " 全てのdiffを更新
  nnoremap <leader>du :diffupdate<CR>

  " mergetool終了
  nnoremap <leader>q :qa<CR>
  nnoremap <leader>w :wa<CR>:qa<CR>

  " ステータスライン設定をdiff用に調整
  set laststatus=2
  set statusline=%f\ %m%r%h%w\ [%{&fileformat}]\ [%{&fileencoding}]\ %=[diff]\ %l,%c\ %p%%
endif

" ----------------------------------------
" mergetool起動時の自動設定
" ----------------------------------------
augroup MergetoolEnhancement
  autocmd!
  " mergetool起動時に自動でdiffモードの設定を適用
  autocmd BufEnter * if &diff | source ~/dotfiles/editors/vim/nvim/mergetool.vim | endif
augroup END