syntax clear markdownError

" highlight note
" make markdownNote highlight inside code block (containedin), but not
" outside codeblock (contained)
syn keyword markdownNote    note Note NOTE note: Note: NOTE: Notes Notes: containedin=markdownCodeBlock contained
hi def link markdownNote    Todo

" Prevent '*' in code fragments being interpreted as italic delimiters
syn clear markdownItalic
syn clear markdownItalicDelimiter
