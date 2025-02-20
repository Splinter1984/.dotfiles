vim9script

def Gitbranch(): string
  var branch = $'%#StatLineSP1#(%*{split(system('git branch --show-current'))[0]}%#StatLineSP1#)%*'
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

def BuflineStr(width: number): string
    return exists('*g:BuflineGetstr') ? g:BuflineGetstr(width) : ''
enddef

var elapsedTime = 0
def GetElapsed(): string
    var mins = elapsedTime % 60
    var hrs = elapsedTime / 60
    return (hrs < 10 ? $'0{hrs}' : string(hrs)) .. ':' .. (mins < 10 ? $'0{mins}' : string(mins))
enddef

def UpdateElapsed(timer: number)
    if exists('#User#ElapsedTimeUpdated')
        :doau <nomodeline> User ElapsedTimeUpdated
    endif
    elapsedTime += 1
    timer_start(60 * 1000, function(UpdateElapsed))
enddef
timer_start(60 * 1000, function(UpdateElapsed))

# Make this function global. 'statusline' option is processed in global context,
# where script-local items are not accessible.
def! g:MyActiveStatusline(): string
    var gitstr = Gitstr()
    var diagstr = Diagstr()
    var gitbranch = $" {Gitbranch()}"
    # Use 1<c-g> or <c-g> to get path to current buffer
    var split_s = '%#StatLineSP#[%*'
    var split_e = '%#StatLineSP#]%*'
    var sourcedir = $"%#StatLineSD#{substitute(getcwd(), '^.*/', '', '')}%*/"
    var shortpath = substitute(expand('%:f'), '^./', '', '')
    if stridx(expand('%:p'), getcwd()) < 0
      shortpath = $'%#StatusLineNC#{shortpath}%*'
    endif
    #var gtags = gutentags#statusline('[', ']')
    # var width = winwidth(0) - 30 - gitstr->len() - diagstr->len() - shortpath->len() - elapsed->len()
    # var width = winwidth(0) - 30 - gitstr->len() - diagstr->len() - elapsed->len()
    # var buflinestr = BuflineStr(width)
    # return $'%4*{diagstr}%* [{shortpath}] %= %y %4*{elapsed}%*%4*{gitstr}%*%2*{shortpath}%* ≡ %P (%l:%c) %*'
    # echom $'{diagstr} {buflinestr} %= %y {elapsed}{shortpath} ≡ %P (%l:%c) '
    # return $'{diagstr} {buflinestr} %= %y {elapsed}{shortpath} ≡ %P (%l:%c) '

    # TODO: call {gutentags#statusline("[","]")}
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
