" cmdline-autocompletion
" ======================================================================

au CmdlineChanged [:/\?] call wildtrigger()
set wim=noselect:lastused,full wop=fuzzy,pum

cnoremap <expr> <up>   wildmenumode() ? "\<c-e>\<up>"   : "\<up>"
cnoremap <expr> <down> wildmenumode() ? "\<c-e>\<down>" : "\<down>"

autocmd CmdlineEnter : exec $'set ph={max([10, winheight(0) - 50])}'
autocmd CmdlineEnter [/\?] set ph=8
autocmd CmdlineLeave [:/\?] set ph&

" autocomplete
" ======================================================================

set autocomplete
set cpt=.^5,w^5,b^5,u^5
set cot=popup

inoremap <silent><expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" fuzzy-file-picker
" ======================================================================

nnoremap <leader><space> :<c-r>=execute('let g:fzfind_root="."')\|''<cr>Find<space>
command! -nargs=* -complete=customlist,<SID>FuzzyFind Find exec $'edit! {s:selected}'

func s:FuzzyFind(cmdarg, cmdline, cursorpos)
  if s:files_cache == []
    let s:files_cache = systemlist(
          \ $'find {get(g:, "fzfind_root", ".")} \! \( -path "*/.git" -prune -o -name "*.sw?" \) -type f -follow')
  endif
  return a:cmdarg == '' ? s:files_cache : matchfuzzy(s:files_cache, a:cmdarg)
endfunc

let s:files_cache = []
autocmd CmdlineEnter : let s:files_cache = []

" buffer
" =====================================================================

nnoremap <leader><bs> :buffer<space>

autocmd CmdlineLeavePre :
      \ if getcmdline() =~ '^\s*b\%[uffer]\s' && get(cmdcomplete_info(), 'matches', []) != []
      \   && cmdcomplete_info().selected == -1 |
      \     call setcmdline($'buffer {cmdcomplete_info().matches[0]}') |
      \ endif

" live-grep
" ======================================================================

nnoremap <leader>g :Grep<space>
nnoremap <leader>G :Grep <c-r>=expand("<cword>")<cr>

command! -nargs=+ -complete=customlist,<SID>GrepComplete Grep call <SID>VisitFile()

func s:GrepComplete(arglead, cmdline, cursorpos)
  let l:cmd = $'grep -REIHns "{a:arglead}" --exclude-dir=.git --exclude=".*" --exclude="tags" --exclude="*.sw?"'
  return len(a:arglead) > 1 ? systemlist(l:cmd) : [] " Trigger after 2 chars
endfunc

func s:VisitFile()
  let l:item = getqflist(#{lines: [s:selected]}).items[0]
  exec $':b +call\ setpos(".",\ [0,\ {l:item.lnum},\ {l:item.col},\ 0]) {l:item.bufnr}'
  call setbufvar(l:item.bufnr, '&buflisted', 1)
endfunc

autocmd CmdlineLeavePre :
      \ if getcmdline() =~ '^\s*\%(Grep\|Find\)\s' && get(cmdcomplete_info(), 'matches', []) != [] |
      \   let s:info = cmdcomplete_info() |
      \   let s:selected = s:info.selected != -1 ? s:info.matches[s:info.selected] : s:info.matches[0] |
      \   call setcmdline(s:info.cmdline_orig) |
      \ endif

