" ----------------------------------------
" NERDTree
" ----------------------------------------
" 隠しファイルを表示する
let NERDTreeShowHidden = 1

" ----------------------------------------
" minibufxpl
" ----------------------------------------
"分割ウィンドウ時に移動を行う設定
noremap <C-H> <C-W>h
noremap <C-J> <C-W>j
noremap <C-K> <C-W>k
noremap <C-L> <C-W>l

" ----------------------------------------
" taglist
" ----------------------------------------
"編集中ファイルのみのタグを表示
"taglistの右側表示
"taglistのみの時に終了
let Tlist_Show_One_File = 1
let Tlist_Use_Right_Window = 1
let Tlist_Exit_OnlyWindow = 1

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
" unite
" ----------------------------------------
let g:unite_enable_start_insert = 1
let g:unite_source_file_mru_filename_format = ''
let g:unite_source_file_mru_limit = 100
let g:unite_split_rule = 'rightbelow'
let g:loaded_unite_source_bookmark = 1
let g:loaded_unite_source_tab = 1
let g:loaded_unite_source_window = 1

" prefix
nnoremap [unite] <Nop>
nmap     <Space>u [unite]

" uniteのショートカットコマンド ,uy などの入力でuniteを起動する
noremap  <silent> [unite]c: <C-u>UniteWithCurrentDir -buffer-name=files
buffer file_mru bookmark file<CR>
nnoremap <silent> [unite]b: <C-u>Unite buffer<CR>
nnoremap <silent> [unite]bd: <C-u>UniteWithBufferDir -buffer-name=files
file<CR>
nnoremap <silent> [unite]s:  <C-u>Unite neosnippet<CR>

" ウィンドウを分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-J>
unite#do_action('split')
au FileType unite inoremap <silent> <buffer> <expr> <C-J>
unite#do_action('split')

" ウィンドウを縦に分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-K> unite#do_action('vsplit')
au FileType unite inoremap <silent> <buffer> <expr> <C-K> unite#do_action('vsplit')

" ESCキーを2回押すと終了する
au FileType unite nnoremap <silent> <buffer> <ESC><ESC> :q<CR>
au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>:q<CR>

" ----------------------------------------
" vim-easy-align
" ----------------------------------------
vmap <Enter> <Plug>(EasyAlign)

" ----------------------------------------
" yankround
" ----------------------------------------
let g:yankround_max_history = 20
nnoremap <C-p> :<C-u>Unite yankround<CR>

" ----------------------------------------
" tagbar
" ----------------------------------------
" keymap
nnoremap <F8> :TagbarToggle<CR>

" ----------------------------------------
" vim-airline
" ----------------------------------------
let g:lightline = {
      \ 'colorscheme': 'wombat',
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

" ----------------------------------------
" neomake
" ----------------------------------------
  let g:go_fmt_command = 'goimports'
  let s:goargs = go#package#ImportPath(expand('%:p:h'))
  let g:neomake_go_errcheck_maker = {
    \ 'args': ['-abspath', s:goargs],
    \ 'append_file': 0,
    \ 'errorformat': '%f:%l:%c:\ %m, %f:%l:%c\ %#%m',
    \ }

  let g:neomake_go_enabled_makers = ['golint', 'govet', 'errcheck']
  let g:neomake_css_enabled_makers = ['csslint', 'stylelint']
  let g:neomake_html_enabled_makers = ['tidy', 'htmlhint']
  let g:neomake_javascript_enabled_makers = ['jshint', 'jscs', 'eslint']

" ----------------------------------------
" Vim-Tags
" ----------------------------------------
 set exrc
 set secure

let g:vim_tags_auto_generate = 1
let g:vim_tags_ignore_files = ['.gitignore', '.svnignore', '.cvsignore']

" ----------------------------------------
" ag.vim
" ----------------------------------------
"  You can configure ag.vim to always start searching from your project root
"  instead of the cwd
let g:ag_working_path_mode="r"

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
" deoplete
" ----------------------------------------
let g:deoplete#enable_at_startup = 1
inoremap <expr><tab> pumvisible() ? "\<C-n>" :
    \ neosnippet#expandable_or_jumpable() ?
    \    "\<Plug>(neosnippet_expand_or_jump)" : "\<tab>"

" ----------------------------------------
" deoplete
" ----------------------------------------
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

" ----------------------------------------
" vim-codefmt
" ----------------------------------------
augroup autoformat_settings
  autocmd FileType bzl AutoFormatBuffer buildifier
  autocmd FileType c,cpp,proto,javascript AutoFormatBuffer clang-format
  autocmd FileType dart AutoFormatBuffer dartfmt
  autocmd FileType go AutoFormatBuffer gofmt
  autocmd FileType gn AutoFormatBuffer gn
  autocmd FileType html,css,json AutoFormatBuffer js-beautify
  autocmd FileType java AutoFormatBuffer google-java-format
  autocmd FileType python AutoFormatBuffer yapf
  " Alternative: autocmd FileType python AutoFormatBuffer autopep8
augroup END
