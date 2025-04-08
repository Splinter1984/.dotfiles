vim9script

def Gitbranch(): string
  var cmd = "git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \\(.*\\)/\\1/'"
  var branch = $'%#StatLineSP1#(%*{system(cmd)[ : -2]}%#StatLineSP1#)%*'
  return stridx(branch, "fatal") != -1 ? '' : branch
enddef

def Gitstr(): string
    var [a, m, r] = exists('*g:GitGutterGetHunkSummary') ? g:GitGutterGetHunkSummary() : [0, 0, 0]
    var gitstat = (a > 0) ? $' %#DiffAdd#+{a}%*' : ''
    gitstat = (m > 0) ? gitstat .. $' %#DiffChange#~{m}%*' : gitstat
    gitstat = (r > 0) ? gitstat .. $' %#DiffDelete#-{r}%*' : gitstat
    return gitstat
enddef

def Diagstr(): string
    var diagstr = ''
    if exists('lsp#lsp#ErrorCount')
        var diag = lsp#lsp#ErrorCount()
        var Severity = (s: string) => {
            return diag[s] != 0 ? $' {s->strpart(0, 1)}:{diag[s]}' : ''
        }
        diagstr = $'%#DiffDelete#{Severity("Error")}%*%#StatLineSP1#{Severity("Warn")}%*{Severity("Hint")}{Severity("Info")}'
    endif
    return diagstr
enddef

# XXX: nice have.
# {{{
# var currentmode = {
#     \ 'n':  'NORMAL',
#     \ 'no': 'NORMAL,OP',
#     \ 'v':  'VISUAL',
#     \ 'V':  'V-LINE',
#     \ '^V': 'V-BLOCK',
#     \ 's':  'SELECT',
#     \ 'S':  'S-LINE',
#     \ '^S': 'S-BLOCK',
#     \ 'i':  'INSERT',
#     \ 'R':  'REPLACE',
#     \ 'Rv': 'V-REPLACE',
#     \ 'c':  'COMMAND',
#     \ 'cv': 'VIM EX',
#     \ 'ce': 'EX',
#     \ 'r':  'PROMPT',
#     \ 'rm': 'MORE',
#     \ 'r?': 'CONFIRM',
#     \ '!':  'SHELL',
#     \ 't':  'TERMINAL'
#     \}
# }}}

# Make this function global. 'statusline' option is processed in global context,
# where script-local items are not accessible.
def! g:MyActiveStatusline(): string
    var gitstr = Gitstr()
    var diagstr = Diagstr()
    var gitbranch = $" {Gitbranch()}"
    # Use 1<c-g> or <c-g> to get path to current buffer
    var split_s = '%#StatLineSP#[%*'
    var split_e = '%#StatLineSP#]%*'
    var sourcedir = $"%#StatLineSD#{substitute(getcwd(), '^.*/', '', '')}%*"
    var shortpath = $"/{substitute(expand('%:f'), '^./', '', '')}"
    var full_path = expand('%:p')
    if len(full_path) > 0 && stridx(full_path, getcwd()) < 0
      shortpath = $'%#StatusLineNC#:{expand('%:f')}%*'
    endif
    # var gtags = gutentags#statusline('[', ']')
    # var width = winwidth(0) - 30 - gitstr->len() - diagstr->len() - shortpath->len() - elapsed->len()
    # var width = winwidth(0) - 30 - gitstr->len() - diagstr->len() - elapsed->len()
    # var buflinestr = BuflineStr(width)
    # return $'%4*{diagstr}%* [{shortpath}] %= %y %4*{elapsed}%*%4*{gitstr}%*%2*{shortpath}%* ≡ %P (%l:%c) %*'
    # echom $'{diagstr} {buflinestr} %= %y {elapsed}{shortpath} ≡ %P (%l:%c) '
    # return $'{diagstr} {buflinestr} %= %y {elapsed}{shortpath} ≡ %P (%l:%c) '

    # XXX: call {gutentags#statusline("[","]")}
    return $'{!empty(shortpath) ? $'{diagstr} {split_s}{sourcedir}{shortpath}{gitstr}{split_e}{gitbranch}' : ''} %#StatLineSP#%=%*%* %y ≡ %P %l:%c%V '
enddef

def! g:MyInactiveStatusline(): string
    return ' %F '
enddef

augroup MyStatusLine | autocmd!
    autocmd WinEnter,BufEnter * setl statusline=%!g:MyActiveStatusline()
    autocmd User LspDiagsUpdated,BufLineUpdated,ElapsedTimeUpdated setl statusline=%!g:MyActiveStatusline()
    autocmd WinLeave,BufLeave * setl statusline=%!g:MyInactiveStatusline()
augroup END
