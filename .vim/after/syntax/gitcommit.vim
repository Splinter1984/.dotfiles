" Vim syntax file
" Language: git commit file
" Maintainer: Tim Pope <vimNOSPAM@tpope.org>
" Filenames:  *.git/COMMIT_EDITMSG
" Last Change:  2022 Jan 05

scriptencoding utf-8

syn case match
syn sync minlines=50
syn sync linebreaks=1

if has("spell")
  syn spell toplevel
endif

hi def link gitcommitSummary              Identifier
hi def link gitcommitTrailerToken         Label
hi def link gitcommitComment              Comment
hi def link gitcommitHash                 Identifier
hi def link gitcommitOnBranch             Comment
hi def link gitcommitBranch               Special
hi def link gitcommitNoBranch             gitCommitBranch
hi def link gitcommitDiscardedType        gitcommitType
hi def link gitcommitSelectedType         gitcommitType
hi def link gitcommitUnmergedType         gitcommitType
hi def link gitcommitType                 Type
hi def link gitcommitNoChanges            gitcommitHeader
hi def link gitcommitHeader               PreProc
hi def link gitcommitUntrackedFile        gitcommitFile
hi def link gitcommitDiscardedFile        gitcommitFile
hi def link gitcommitSelectedFile         gitcommitFile
hi def link gitcommitUnmergedFile         gitcommitFile
hi def link gitcommitFile                 Constant
hi def link gitcommitDiscardedArrow       gitcommitArrow
hi def link gitcommitSelectedArrow        gitcommitArrow
hi def link gitcommitUnmergedArrow        gitcommitArrow
hi def link gitcommitArrow                gitcommitComment
"hi def link gitcommitOverflow    Error
hi def link gitcommitBlank                Error

let b:current_syntax = "gitcommit"
