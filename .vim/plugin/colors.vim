augroup ColorMonochrome
  autocmd!
  " FileType event is not called every time buffer is switched.
  " BufReadPost will not have &filetype. So defer until filetype
  " is detected.
  autocmd WinEnter,BufEnter,BufReadPost *
        \ call timer_start(10, function('ApplyColors'))
augroup END

function! ApplyColors(timer) abort

  hi Comment      ctermfg=8
  hi Constant     ctermfg=4
  hi String       ctermfg=6
  hi Character    ctermfg=6
  hi Boolean      ctermfg=5
  hi Identifier   ctermfg=4
  hi Function     ctermfg=2
  hi Statement    ctermfg=1
  hi PreProc      ctermfg=2
  hi Type         ctermfg=3
  hi Special      ctermfg=2
  hi SpecialChar  ctermfg=5

  call SaneColors()
endfunction


function! SaneColors() abort

  hi Normal         ctermfg=none ctermbg=none

  hi ColorColumn    ctermfg=none ctermbg=0
  hi Conceal        ctermfg=0    ctermbg=none
  hi CursorColumn   ctermfg=none ctermbg=0
  hi CursorLine     ctermfg=none ctermbg=0    cterm=none
  hi CursorLineNr   ctermfg=3    ctermbg=0    cterm=none
  hi CursorLineSign ctermfg=none ctermbg=0    cterm=none

  hi Added          ctermfg=2    ctermbg=none
  hi Changed        ctermfg=5    ctermbg=none
  hi Removed        ctermfg=1    ctermbg=none

  hi! def link DiffAdd      Added
  hi! def link DiffChange   Changed
  hi! def link DiffDelete   Removed

  hi VertSplit      cterm=none   ctermbg=none cterm=none

  hi SignColumn     ctermfg=none ctermbg=none
  hi LineNr         ctermfg=8    ctermbg=none
  hi Visual         ctermfg=none ctermbg=none cterm=reverse
  hi StatusLine     ctermfg=none ctermbg=none cterm=none
  hi StatusLineNC   ctermfg=7    ctermbg=none cterm=none
  hi MatchParen     ctermfg=none ctermbg=none cterm=reverse

  " special highlight for statusline
  hi StatLineSP     ctermfg=2    ctermbg=none
  hi StatLineSP1    ctermfg=3    ctermbg=none
  hi StatLineSD     ctermfg=4    ctermbg=none

  hi Search         ctermfg=none ctermbg=none cterm=reverse
  hi CurSearch      ctermfg=3    ctermbg=none cterm=reverse

  hi Error          ctermfg=1    ctermbg=none cterm=reverse
  hi Pmenu          ctermfg=none ctermbg=7    cterm=none
  hi PmenuMatch     ctermfg=3    ctermbg=7    cterm=none
  hi PmenuMatchSel  ctermfg=3    ctermbg=7    cterm=reverse,bold
  hi PmenuSel       ctermfg=none ctermbg=none cterm=reverse
  hi PmenuThumb     ctermfg=8    ctermbg=8    cterm=none
  hi PmenuSbar      ctermfg=7    ctermbg=7    cterm=none

  hi SpellBad       ctermfg=none ctermbg=none cterm=underline
  hi SpellCap       ctermfg=none ctermbg=none cterm=underline
  hi SpellLocal     ctermfg=none ctermbg=none cterm=underline
  hi SpellRare      ctermfg=none ctermbg=none cterm=underline

  hi SpecialKey     ctermfg=8    ctermbg=none cterm=bold

  hi Todo           ctermfg=none ctermbg=none cterm=bold,underline

endfunction

" Following should occur after setting colorscheme.
highlight! TrailingWhitespace cterm=reverse
match TrailingWhitespace /\s\+\%#\@<!$/

