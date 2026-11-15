" 設定ファイルの実体を基準にし、シンボリックリンク経由でも既存の取得先を再利用する。
let s:config_dir = fnamemodify(resolve(expand('<sfile>:p')), ':h')
let g:dotfiles_plugin_base = fnamemodify(s:config_dir, ':h') . '/plugins'
let s:dpp_config = s:config_dir . '/dpp.ts'

" dpp 自身の初回起動に必要な4件だけは Git で取得する。
" clone 失敗時は中断し、壊れた runtimepath のまま後続設定を読み込まない。
for s:repo in ['vim-denops/denops.vim', 'Shougo/dpp.vim', 'Shougo/dpp-ext-installer', 'Shougo/dpp-protocol-git']
  let s:path = g:dotfiles_plugin_base . '/repos/github.com/' . s:repo
  if !isdirectory(s:path)
    call mkdir(fnamemodify(s:path, ':h'), 'p')
    call system('git clone ' . shellescape('https://github.com/' . s:repo . '.git') . ' ' . shellescape(s:path))
    if v:shell_error
      throw 'プラグインの取得に失敗: ' . s:repo
    endif
  endif
  execute 'set runtimepath^=' . fnameescape(s:path)
endfor

" dpp のヘルプ結合は symlink を作るため、Deno の仕様上 --allow-write のパス制限は使えない。
" 書き込みを許可し、外部コマンド実行はプラグイン取得・キャッシュ用の Git / Deno に限定する。
" Git の実行は installer 用。共有サーバーがなくても個別サーバーで初回構築できる。
let g:denops#deno = exepath('deno')
let g:denops#deno_dir = stdpath('cache') . '/denops/deno'
let g:denops#server#deno_args = [
      \ '-q', '--no-lock', '--allow-env', '--allow-read', '--allow-net',
      \ '--allow-run=git,deno', '--allow-write',
      \ ]

function! s:make_state() abort
  call dpp#make_state(g:dotfiles_plugin_base, s:dpp_config)
endfunction

function! s:install() abort
  " 一覧変更後も新しい状態を先に作り、追加したプラグインを installer に渡す。
  let s:install_pending = 1
  call s:make_state()
endfunction

function! s:state_ready() abort
  if get(s:, 'install_pending', 0)
    let s:install_pending = 0
    call dpp#min#load_state(g:dotfiles_plugin_base)
    filetype plugin indent on
    if !empty(dpp#sync_ext_action('installer', 'getNotInstalled'))
      call dpp#async_ext_action('installer', 'install')
    else
      echomsg '必要なプラグインは導入済みです。Neovim を再起動してください。'
    endif
  else
    echomsg 'dpp の状態を作成しました。Neovim を再起動してください。'
  endif
endfunction

augroup DotfilesDpp
  autocmd!
  autocmd User Dpp:makeStatePost call s:state_ready()
  " 取得後の状態を再生成し、次回起動から追加プラグインも読み込む。
  autocmd User Dpp:ext:installer:updateDone call s:make_state()
augroup END

command! DppCache call s:make_state()
command! DppInstall call s:install()
command! -nargs=* DppUpdate call dpp#async_ext_action('installer', 'update', {'names': split(<q-args>)})

" Neovim の filetype off が未定義グループを参照しないよう、検出を先に初期化する。
filetype plugin indent on
let g:dotfiles_plugins_ready = !dpp#min#load_state(g:dotfiles_plugin_base)
filetype plugin indent on
syntax enable
if !g:dotfiles_plugins_ready
  " 初回は denops の準備後に状態生成・取得を行い、通常設定は再起動後に読む。
  autocmd DotfilesDpp User DenopsReady ++once call s:install()
endif
