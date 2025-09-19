" ----------------------------------------
" NERDTree
" ----------------------------------------
" 隠しファイルを表示する
let NERDTreeShowHidden = 1

" WinEnterエラー回避のための安全な設定
let g:NERDTreeQuitOnOpen = 0
let g:NERDTreeAutoDeleteBuffer = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeDirArrows = 1

" 自動クローズ機能を無効化してエラーを回避
let g:NERDTreeChDirMode = 0

" vim-nerdtree-tabsとの競合回避
let g:nerdtree_tabs_open_on_console_startup = 0
let g:nerdtree_tabs_focus_on_files = 1
let g:nerdtree_tabs_smart_startup_focus = 1

" 削除済み: minibufexpl設定

" WinEnterイベントでのエラーハンドリング強化
augroup NERDTreeErrorHandling
  autocmd!
  " NERDTreeウィンドウでのエラーを安全に処理
  autocmd WinEnter * if exists("t:NERDTreeBufName") && bufname() == t:NERDTreeBufName | silent! call nerdtree#ui_glue#invoke_key_map('p') | endif
augroup END

" ----------------------------------------
" 分割ウィンドウ移動設定
" ----------------------------------------
noremap <C-H> <C-W>h
noremap <C-J> <C-W>j
noremap <C-K> <C-W>k
noremap <C-L> <C-W>l


" ----------------------------------------
" vim-indent-line
" ----------------------------------------
" Enable by default
let g:indentLine_enabled = 1
" Tabs support
set list lcs=tab:\|\ " (here is a space)
" Change character color for Vim
let g:indentLine_color_term = 239
let g:indentLine_color_tty_light = 7 " (default: 4)
let g:indentLine_color_dark = 1 " (default: 2)

" ----------------------------------------
" yanktmp
" ----------------------------------------
nnoremap <silent> sy :call YanktmpYank()<CR>
nnoremap <silent> sp :call YanktmpPaste_p()<CR>
nnoremap <silent> sP :call YanktmpPaste_P()<CR>

" ----------------------------------------
" telescope.nvim
" ----------------------------------------
" prefix
nnoremap [telescope] <Nop>
nmap     <Space>t [telescope]

" telescopeのショートカットコマンド
nnoremap <silent> [telescope]f <cmd>Telescope find_files<cr>
nnoremap <silent> [telescope]g <cmd>Telescope live_grep<cr>
nnoremap <silent> [telescope]b <cmd>Telescope buffers<cr>
nnoremap <silent> [telescope]h <cmd>Telescope help_tags<cr>
nnoremap <silent> [telescope]r <cmd>Telescope oldfiles<cr>
nnoremap <silent> [telescope]s <cmd>Telescope lsp_document_symbols<cr>

" ----------------------------------------
" vim-easy-align
" ----------------------------------------
vmap <Enter> <Plug>(EasyAlign)

" ----------------------------------------
" yankround
" ----------------------------------------
let g:yankround_max_history = 20
" nnoremap <C-p> :<C-u>Unite yankround<CR>  " 古いunite設定

" ----------------------------------------
" tagbar
" ----------------------------------------
" keymap
nnoremap <F8> :TagbarToggle<CR>

" ----------------------------------------
" lualine.nvim
" ----------------------------------------
let g:lightline = {
      \ 'colorscheme': 'solarized_dark',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ], ['ctrlpmark'] ],
      \   'right': [ [ 'syntastic', 'lineinfo' ], ['percent'], [ 'fileformat', 'fileencoding', 'filetype' ] ]
      \ },
      \ 'component_function': {
      \   'fugitive': 'LightLineFugitive',
      \   'filename': 'LightLineFilename',
      \   'fileformat': 'LightLineFileformat',
      \   'filetype': 'LightLineFiletype',
      \   'fileencoding': 'LightLineFileencoding',
      \   'mode': 'LightLineMode',
      \   'ctrlpmark': 'CtrlPMark',
      \ },
      \ 'component_expand': {
      \   'syntastic': 'SyntasticStatuslineFlag',
      \ },
      \ 'component_type': {
      \   'syntastic': 'error',
      \ },
      \ 'subseparator': { 'left': '|', 'right': '|' }
      \ }

function! LightLineModified()
  return &ft =~ 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! LightLineReadonly()
  return &ft !~? 'help' && &readonly ? 'RO' : ''
endfunction

function! LightLineFilename()
  let fname = expand('%:t')
  return fname == 'ControlP' ? g:lightline.ctrlp_item :
        \ fname == '__Tagbar__' ? g:lightline.fname :
        \ fname =~ '__Gundo\|NERD_tree' ? '' :
        \ &ft == 'vimfiler' ? vimfiler#get_status_string() :
        \ &ft == 'unite' ? unite#get_status_string() :
        \ &ft == 'vimshell' ? vimshell#get_status_string() :
        \ ('' != LightLineReadonly() ? LightLineReadonly() . ' ' : '') .
        \ ('' != fname ? fname : '[No Name]') .
        \ ('' != LightLineModified() ? ' ' . LightLineModified() : '')
endfunction

function! LightLineFugitive()
  try
    if expand('%:t') !~? 'Tagbar\|Gundo\|NERD' && &ft !~? 'vimfiler' && exists('*fugitive#head')
      let mark = ''  " edit here for cool mark
      let _ = fugitive#head()
      return strlen(_) ? mark._ : ''
    endif
  catch
  endtry
  return ''
endfunction

function! LightLineFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightLineFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! LightLineFileencoding()
  return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! LightLineMode()
  let fname = expand('%:t')
  return fname == '__Tagbar__' ? 'Tagbar' :
        \ fname == 'ControlP' ? 'CtrlP' :
        \ fname == '__Gundo__' ? 'Gundo' :
        \ fname == '__Gundo_Preview__' ? 'Gundo Preview' :
        \ fname =~ 'NERD_tree' ? 'NERDTree' :
        \ &ft == 'unite' ? 'Unite' :
        \ &ft == 'vimfiler' ? 'VimFiler' :
        \ &ft == 'vimshell' ? 'VimShell' :
        \ winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! CtrlPMark()
  if expand('%:t') =~ 'ControlP'
    call lightline#link('iR'[g:lightline.ctrlp_regex])
    return lightline#concatenate([g:lightline.ctrlp_prev, g:lightline.ctrlp_item
          \ , g:lightline.ctrlp_next], 0)
  else
    return ''
  endif
endfunction

let g:ctrlp_status_func = {
  \ 'main': 'CtrlPStatusFunc_1',
  \ 'prog': 'CtrlPStatusFunc_2',
  \ }

function! CtrlPStatusFunc_1(focus, byfname, regex, prev, item, next, marked)
  let g:lightline.ctrlp_regex = a:regex
  let g:lightline.ctrlp_prev = a:prev
  let g:lightline.ctrlp_item = a:item
  let g:lightline.ctrlp_next = a:next
  return lightline#statusline(0)
endfunction

function! CtrlPStatusFunc_2(str)
  return lightline#statusline(0)
endfunction

let g:tagbar_status_func = 'TagbarStatusFunc'

function! TagbarStatusFunc(current, sort, fname, ...) abort
    let g:lightline.fname = a:fname
  return lightline#statusline(0)
endfunction

augroup AutoSyntastic
  autocmd!
  autocmd BufWritePost *.c,*.cpp call s:syntastic()
augroup END
function! s:syntastic()
  SyntasticCheck
  call lightline#update()
endfunction

let g:unite_force_overwrite_statusline = 0
let g:vimfiler_force_overwrite_statusline = 0
let g:vimshell_force_overwrite_statusline = 0

" Automatic colorscheme detection for lightline
augroup LightlineColorScheme
  autocmd!
  autocmd ColorScheme * call LightlineUpdate()
augroup END

function! LightlineUpdate()
  " Update lightline colorscheme based on current vim colorscheme
  if exists('g:colors_name')
    if g:colors_name ==# 'solarized'
      if &background ==# 'dark'
        let g:lightline.colorscheme = 'solarized_dark'
      else
        let g:lightline.colorscheme = 'solarized_light'
      endif
    else
      " Use wombat as fallback for other colorschemes
      let g:lightline.colorscheme = 'wombat'
    endif
    
    " Update lightline if it's already loaded
    if exists(':LightlineReload')
      LightlineReload
    endif
  endif
endfunction

" ----------------------------------------
" nvim-lint + conform.nvim
" ----------------------------------------
" これらの設定はluaで行う（lsp-config.luaで設定）

" ----------------------------------------
" Vim-Tags
" ----------------------------------------
 set exrc
 set secure

let g:vim_tags_auto_generate = 1
let g:vim_tags_ignore_files = ['.gitignore', '.svnignore', '.cvsignore']

" ----------------------------------------
" 検索機能 (telescope.nvimで代替)
" ----------------------------------------
" 削除済み: ag.vim設定

" ----------------------------------------
" vim-go
" ----------------------------------------
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

let g:go_fmt_command = "goimports"

" ----------------------------------------
" vim-tags.
" ----------------------------------------
let g:vim_tags_auto_generate = 1
let g:vim_tags_use_language_field = 1
let g:vim_tags_ignore_files = ['.gitignore', '.svnignore', '.cvsignore']
let g:vim_tags_directories = [".git", ".hg", ".svn", ".bzr", "_darcs", "CVS"]

" ----------------------------------------
" denops.vim
" ----------------------------------------
" Deno実行ファイルのパスを明示的に指定
let g:denops#deno = '/opt/homebrew/bin/deno'

" Denoサーバーの引数設定（セキュリティ重視・最小権限の原則）
let g:denops#server#deno_args = ['-q', '--no-lock', '--allow-env', '--allow-read', '--allow-net']

" バージョンチェック無効化（互換性問題回避）
let g:denops_disable_version_check = 1

" denopsのデバッグモード（必要時のみ有効化）
let g:denops#debug = 0

" 推奨設定：Ctrl+Cでの割り込み処理
noremap <silent> <C-c> <Cmd>call denops#interrupt()<CR><C-c>
inoremap <silent> <C-c> <Cmd>call denops#interrupt()<CR><C-c>
cnoremap <silent> <C-c> <Cmd>call denops#interrupt()<CR><C-c>

" 推奨コマンド：denopsサーバー再起動
command! DenopsRestart call denops#server#restart()

" 推奨コマンド：Denoキャッシュ修復
command! DenopsFixCache call denops#cache#update(#{reload: v:true})

" ----------------------------------------
" denops共有サーバー設定（接続問題の確実な解決）
" ----------------------------------------
" 使用方法：
" 1. 最初に :DenopsSharedServer を実行して共有サーバーを起動
" 2. Vimを再起動するとdenopsが共有サーバーに接続
" 3. 問題があれば以下のコマンドで状況確認:
"    :DenopsCheck  - サーバープロセス確認
"    :DenopsStatus - denops接続状況確認
"    :DenopsLog    - サーバーログ確認
"    :DenopsRestart - denops再起動
"
" 共有サーバーアドレスの設定（個別サーバー起動問題を回避）
let g:denops_server_addr = '127.0.0.1:32123'

" 共有サーバー起動コマンド（改善版 - より確実な起動）
function! s:start_denops_shared_server() abort
  let l:denops_dir = expand('~/dotfiles/editors/vim/plugins/repos/github.com/vim-denops/denops.vim')
  let l:deno_path = '/opt/homebrew/bin/deno'
  let l:script_path = l:denops_dir . '/denops/@denops-private/cli.ts'

  " サーバーが既に起動しているかチェック
  let l:ps_result = system('ps aux | grep "deno.*cli.ts" | grep -v grep')
  if !empty(l:ps_result)
    echo "denops共有サーバーは既に起動しています"
    echo l:ps_result
    return
  endif

  " サーバー起動（公式推奨の-Aフラグ使用）
  let l:cmd = printf('cd %s && nohup %s run -A --no-lock %s --hostname=127.0.0.1 --port=32123 > /tmp/denops-server.log 2>&1 &',
        \ shellescape(l:denops_dir),
        \ shellescape(l:deno_path),
        \ shellescape(l:script_path))

  let l:result = system(l:cmd)
  if v:shell_error == 0
    echo "denops共有サーバーを起動しました。数秒後に :DenopsCheck で確認してください"
    echo "ログ確認: :DenopsLog"
  else
    echo "エラー: サーバー起動に失敗しました"
    echo "エラー詳細: " . l:result
    echo "ログ確認: :DenopsLog"
  endif
endfunction

command! DenopsSharedServer call s:start_denops_shared_server()

" 自動起動機能（オプション - 有効にするには以下をアンコメント）
" augroup DenopsAutoStart
"   autocmd!
"   autocmd VimEnter * call s:auto_start_denops_if_needed()
" augroup END

function! s:auto_start_denops_if_needed() abort
  " 共有サーバーアドレスが設定されている場合のみ自動起動を試行
  if exists('g:denops_server_addr') && !empty(g:denops_server_addr)
    " サーバーが起動しているかチェック
    let l:ps_result = system('ps aux | grep "deno.*cli.ts" | grep -v grep')
    if empty(l:ps_result)
      echo "denops共有サーバーが見つかりません。自動起動を試行します..."
      call s:start_denops_shared_server()
      " 少し待ってから接続を試行
      sleep 2
    endif
  endif
endfunction

" denops接続状況確認コマンド
command! DenopsStatus echo denops#server#status()

" 共有サーバープロセス確認コマンド（改善版）
function! s:check_denops_server() abort
  let l:ps_result = system('ps aux | grep "deno.*cli.ts" | grep -v grep')
  if !empty(l:ps_result)
    echo "denops共有サーバーは起動中です:"
    echo l:ps_result
    echo "\nログ確認: :DenopsLog"
  else
    echo "denops共有サーバーは起動していません"
    echo "起動するには: :DenopsSharedServer"
  endif
endfunction

command! DenopsCheck call s:check_denops_server()
command! DenopsLog !tail -20 /tmp/denops-server.log

" ----------------------------------------
" ddc.vim
" ----------------------------------------
" denopsが利用可能になってからddc設定を実行
augroup DDCConfig
  autocmd!
  autocmd User DenopsReady call s:ddc_setup()
augroup END

function! s:ddc_setup() abort
  try
    " ddc基本設定
    call ddc#custom#patch_global('ui', 'pum')
    call ddc#custom#patch_global('sources', ['around', 'lsp'])
    call ddc#custom#patch_global('sourceOptions', {
    \ '_': {'matchers': ['matcher_head'], 'sorters': ['sorter_rank']},
    \ 'around': {'mark': 'A'},
    \ 'lsp': {'mark': 'L', 'dup': v:true},
    \ })

    " ddc有効化
    call ddc#enable()

    echo "ddc.vim initialized successfully with secure denops configuration"
  catch
    echo "Error initializing ddc.vim: " . v:exception
  endtry
endfunction

" denopsが既に利用可能な場合は即座に設定実行
if denops#plugin#is_loaded('ddc')
  call s:ddc_setup()
endif

" Tab completion for ddc.vim
inoremap <expr><tab> pumvisible() ? "\<C-n>" :
    \ neosnippet#expandable_or_jumpable() ?
    \    "\<Plug>(neosnippet_expand_or_jump)" : "\<tab>"
inoremap <expr><s-tab> pumvisible() ? "\<C-p>" : "\<s-tab>"

" ----------------------------------------
" bufferline.nvim
" ----------------------------------------
" bufferlineのナビゲーション
nnoremap <silent> [b :BufferLineCyclePrev<CR>
nnoremap <silent> ]b :BufferLineCycleNext<CR>
nnoremap <silent> <leader>bp :BufferLineTogglePin<CR>
nnoremap <silent> <leader>bc :BufferLinePickClose<CR>

" ----------------------------------------
" toggleterm.nvim
" ----------------------------------------
" Toggleterm keymaps
nnoremap <silent> <C-t> :ToggleTerm<CR>
tnoremap <silent> <C-t> <C-\><C-n>:ToggleTerm<CR>


