" vim: ft=vim:fdm=marker

" ==============================================================================
" Vim syntax file
" Language:        C Additions
" Original Author: Mikhail Wolfson, Jon Haggblad <https://github.com/octol>
" Fork Maintainer: splitner1984 <https://github.com/splinter1984>
" Last Change:     Feb 27, 2025
" ==============================================================================


" Highlight additional keywords in the comments
syn keyword cTodo TODO FIXME BUG NOTE todo fixme bug note contained

" see for :h c.vim
g:c_syntax_for_h = 1

" Highlight function names
syn match cUserFunction "\<\h\w*\ze\_s\{-}(\%(\*\h\w*)\_s\{-}(\)\@!"
syn match cUserFunctionPointer "\%((\s*\*\s*\)\@6<=\h\w*\ze\s*)\_s\{-}(.*)"
hi def link cUserFunction Function
hi def link cUserFunctionPointer Function


" Highlight struct/class member variables
syn match cMemberAccess "\.\|->" nextgroup=cStructMember,cppTemplateKeyword
hi def link cMemberAccess MemberAccess
syn match cStructMember "\<\h\w*\>\%((\|<\)\@!" contained
syn cluster cParenGroup add=cStructMember
syn cluster cPreProcGroup add=cStructMember
syn cluster cMultiGroup add=cStructMember
hi! def link cStructMember Identifier

if &filetype ==# 'cpp'
    syn keyword cppTemplateKeyword template
    hi def link cppTemplateKeyword cppStructure
endif


" Highlight names in struct, union and enum declarations
syn match cTypeName "\%(\%(\<struct\|union\|enum\)\s\+\)\@8<=\h\w*"
syn match cType "\h\w*_t\w\@!"
hi def link cTypeName Type
hi def link cType     Type

if &filetype ==# 'cpp'
    syn match cTypeName "\%(\%(\<class\|using\|concept\|requires\)\s\+\)\@10<=\h\w*"
endif


" Highlight operators
syn match cOperator "[?!~*&%<>^|=,+]"
syn match cOperator "[][]"
syn match cOperator "[^:]\@1<=:[^:]\@="
syn match cOperator "-[^>]"me=e-1
syn match cOperator "/[^/*]"me=e-1
hi! def link cOperator MemberAccess


" Common ANSI-standard Names
syn keyword cAnsiName
        \ PRId8 PRIi16 PRIo32 PRIu64 PRId16 PRIi32 PRIo64 PRIuLEAST8 PRId32 PRIi64 PRIoLEAST8 PRIuLEAST16 PRId64 PRIiLEAST8 PRIoLEAST16 PRIuLEAST32 PRIdLEAST8 PRIiLEAST16 PRIoLEAST32 PRIuLEAST64 PRIdLEAST16 PRIiLEAST32 PRIoLEAST64 PRIuFAST8 PRIdLEAST32 PRIiLEAST64 PRIoFAST8 PRIuFAST16 PRIdLEAST64 PRIiFAST8 PRIoFAST16 PRIuFAST32 PRIdFAST8 PRIiFAST16 PRIoFAST32 PRIuFAST64 PRIdFAST16 PRIiFAST32 PRIoFAST64 PRIuMAX PRIdFAST32 PRIiFAST64 PRIoMAX PRIuPTR PRIdFAST64 PRIiMAX PRIoPTR PRIx8 PRIdMAX PRIiPTR PRIu8 PRIx16 PRIdPTR PRIo8 PRIu16 PRIx32 PRIi8 PRIo16 PRIu32 PRIx64 PRIxLEAST8 SCNd8 SCNiFAST32 SCNuLEAST32 PRIxLEAST16 SCNd16 SCNiFAST64 SCNuLEAST64 PRIxLEAST32 SCNd32 SCNiMAX SCNuFAST8 PRIxLEAST64 SCNd64 SCNiPTR SCNuFAST16 PRIxFAST8 SCNdLEAST8 SCNo8 SCNuFAST32 PRIxFAST16 SCNdLEAST16 SCNo16 SCNuFAST64 PRIxFAST32 SCNdLEAST32 SCNo32 SCNuMAX PRIxFAST64 SCNdLEAST64 SCNo64 SCNuPTR PRIxMAX SCNdFAST8 SCNoLEAST8 SCNx8 PRIxPTR SCNdFAST16 SCNoLEAST16 SCNx16 PRIX8 SCNdFAST32 SCNoLEAST32 SCNx32 PRIX16 SCNdFAST64 SCNoLEAST64 SCNx64 PRIX32 SCNdMAX SCNoFAST8 SCNxLEAST8 PRIX64 SCNdPTR SCNoFAST16 SCNxLEAST16 PRIXLEAST8 SCNi8 SCNoFAST32 SCNxLEAST32 PRIXLEAST16 SCNi16 SCNoFAST64 SCNxLEAST64 PRIXLEAST32 SCNi32 SCNoMAX SCNxFAST8 PRIXLEAST64 SCNi64 SCNoPTR SCNxFAST16 PRIXFAST8 SCNiLEAST8 SCNu8 SCNxFAST32 PRIXFAST16 SCNiLEAST16 SCNu16 SCNxFAST64 PRIXFAST32 SCNiLEAST32 SCNu32 SCNxMAX PRIXFAST64 SCNiLEAST64 SCNu64 SCNxPTR PRIXMAX SCNiFAST8 SCNuLEAST8 PRIXPTR SCNiFAST16 SCNuLEAST16 STDC CX_LIMITED_RANGE STDC FENV_ACCESS STDC FP_CONTRACT
        \ errno environ and bitor not_eq xor and_eq compl or xor_eq bitand not or_eq

" Booleans
syn keyword cBoolean true false TRUE FALSE

" Default highlighting
hi def link cBoolean    Boolean
hi def link cAnsiName   Identifier
hi def link cConstant   Boolean

" Highlight all standard C keywords as Statement
" This is very similar to what other IDEs and editors do
hi! def link cStorageClass Statement
hi! def link cStructure    Statement
hi! def link cTypedef      Statement
hi! def link cLabel        Statement
