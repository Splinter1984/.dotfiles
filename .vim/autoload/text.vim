vim9script

# Fix text:
# * replace non-breaking spaces with spaces
# * replace multiple spaces with a single space (preserving indent)
# * remove spaces between closed braces: ) ) -> ))
# * remove space before closed brace: word ) -> word)
# * remove space after opened brace: ( word -> (word
# * remove space at the end of line
# Usage:
# command! -range FixSpaces call text#fix_spaces(<line1>,<line2>)
export def FixSpaces(line1: number, line2: number)
    var view = winsaveview()
    defer winrestview(view)
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
enddef

