vim9script

export def Surround(c: string)
    if mode() == 'n'
        :normal! diw
        :exe $'normal! i{c}{c}'
        :normal! P
    elseif mode() != 'CTRL-V'
        var [line_start, col_start] = getpos('v')[1 : 2]
        var [line_end, col_end] = getpos('.')[1 : 2]
        if mode() == 'V'
            col_start = 0
            col_end = v:maxcol
        endif
        var reverse = line_start > line_end || (line_start == line_end && col_start > col_end)
        for lnum in range(line_start, line_end, reverse ? -1 : 1)
            var line = lnum->getline()
            var start = lnum == line_start ? col_start - 1 : (reverse ? line->len() : 0)
            var end = lnum == line_end ? col_end - 1 : (reverse ? 0 : line->len())
            var newline = reverse ?
                $'{line->strpart(0, end)}{c}{line->strpart(end, start - end + 1)}{c}{line->strpart(start + 1)}' :
                $'{line->strpart(0, start)}{c}{line->strpart(start, end - start + 1)}{c}{line->strpart(end + 1)}'
            newline->setline(lnum)
        endfor
    endif
enddef

# Fix spaces in text:
# * replace non-breaking spaces with spaces
# * replace multiple spaces with a single space (preserving indent)
# * remove spaces between closed braces: ') )' -> '))'
# * remove space before closed brace: 'word )' -> 'word)'
# * remove space after opened brace: '( word' -> '(word'
# * remove space at the end of line
# Usage:
command! -range FixSpaces call text#FixSpaces(<line1>, <line2>)
export def FixSpaces(line1: number, line2: number)
    var view = winsaveview()
    # replace non-breaking space to space first
    exe printf('silent :%d,%ds/\%%xA0/ /ge', line1, line2)
    # replace multiple spaces to a single space (preserving indent)
    exe printf('silent :%d,%ds/\S\+\zs\(\s\|\%%xa0\)\+/ /ge', line1, line2)
    # remove spaces between closed braces: ) ) -> ))
    exe printf('silent :%d,%ds/)\s\+)\@=/)/ge', line1, line2)
    # remove spaces between opened braces: ( ( -> ((
    exe printf('silent :%d,%ds/(\s\+(\@=/(/ge', line1, line2)
    # remove space before closed brace: word ) -> word)
    exe printf('silent :%d,%ds/\s)/)/ge', line1, line2)
    # remove space after opened brace: ( word -> (word
    exe printf('silent :%d,%ds/(\s/(/ge', line1, line2)
    # remove space at the end of line
    exe printf('silent :%d,%ds/\s*$//ge', line1, line2)
    winrestview(view)
enddef
