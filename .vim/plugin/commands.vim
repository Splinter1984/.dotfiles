vim9script

# Find highlight group under cursor
def HighlightGroupUnderCursor()
    if exists("*synstack")
        for grp in synstack(line('.'), col('.'))->mapnew('synIDattr(v:val, "name")')
            echo 'Group:' grp
            var g = grp
            while true
                var linksto = $'hi {g}'->execute()->matchstr('links to \zs\S\+')
                if linksto == null_string
                    exec 'verbose hi' g
                    break
                else
                    echo '->' linksto
                    g = linksto
                endif
            endwhile
        endfor
    endif
enddef
command! HighlightGroupUnderCursor HighlightGroupUnderCursor()

# Wipe all hidden buffers
def WipeHiddenBuffers()
    var buffers = filter(getbufinfo(), (_, v) => empty(v.windows))
    if !empty(buffers)
        execute 'confirm bwipeout' join(mapnew(buffers, (_, v) => v.bufnr))
    endif
enddef
command! WipeHiddenBuffers WipeHiddenBuffers()

# fix trailing spaces
command! FixTrailingSpaces :exe 'normal! m`'<bar>
      \ :keepj silent! :%s/\r\+$//g<bar>
      \ :keepj silent! :%s/\v(\s+$)//g<bar>
      \ :exe 'normal! ``'<bar>
      \ :echom 'Remove trailing spaces and ^Ms.'

import autoload "text.vim"
command! -range FixSpaces text.FixSpaces(<line1>, <line2>)

# syntax group names under cursor
command! Inspect :echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
