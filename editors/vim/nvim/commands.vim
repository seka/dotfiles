" ----------------------------------------
" command
" ----------------------------------------
" vimrc read/write
command! Ev edit $MYVIMRC
command! Rv source $MYVIMRC

" count string in file
command! -nargs=0 Wc %s/.//nge

" 保存済みの現在ファイルを監視する。無名・未保存の新規ファイルは開かず、
" 空白を含むパスも一つの引数として渡して、保存時にプレビューを更新する。
function! s:PreviewLeaf() abort
  let l:path = expand("%:p")
  if empty(l:path) || !filereadable(l:path)
    echoerr "Leaf: 先にファイルを保存してください"
    return
  endif
  if !executable("leaf")
    echoerr "Leaf: leaf コマンドが見つかりません"
    return
  endif

  let l:cmd = "leaf -w -- " . shellescape(l:path)
  if has("nvim")
    botright vnew
    execute "terminal " . l:cmd
  else
    execute "vertical botright terminal " . l:cmd
  endif
endfunction

command! -nargs=0 Leaf call s:PreviewLeaf()
