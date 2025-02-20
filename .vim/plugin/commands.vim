vim9script

# Find highlight group under cursor
command HighlightGroupUnderCursor {
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
}
