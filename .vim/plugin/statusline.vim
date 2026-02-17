vim9script

def Gitbranch(): string
  var branch_name: string = system("git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/*\\s\\(.*\\)/\\1/'")[ : -2]
  return (empty(branch_name) || (stridx(branch_name, "fatal") != -1)) ? '' : $'%#StatLineSP1#(%*{branch_name}%#StatLineSP1#)%*'
enddef

def Gitnumstat(): string
  var m: list<string> = matchlist(system($"git diff --no-color --numstat {eval('@%')} 2> /dev/null"), '\(\d\+\)\s\+\(\d\+\)')
  return (!empty(m) ? ((m[1] != '0' ? $" %#DiffAdd#+{m[1]}%*" : "") .. (m[2] != '0' ? $" %#DiffDelete#-{m[2]}%*" : "")) : "")
enddef

def Sourcepath(): string
  var [fcwd, fcwb] = [getcwd(), expand("%:p")]
  return $"%#StatLineSD#{substitute(fcwd, "^.*/", '', '')}%*{!empty(fcwb) ? (!empty(matchstr(fcwb, fcwd)) ? $"/{expand("%:p:.")}" : $"%#StatusLineNC#:{fcwb}%*") : ''}"
enddef

# Make this function global. 'statusline' option is processed in global context,
# where script-local items are not accessible.
def! g:StatuslineActive(): string
  return $'%#StatLineSP# [%*{Sourcepath()}{!empty(expand("%:p")) ? Gitnumstat() : ""}%#StatLineSP#] %*{Gitbranch()}%#StatLineSP# %=%*%* %y ≡ %P %l:%c%V '
enddef

def! g:StatuslineInactive(): string
  return ' %F '
enddef

augroup statusline_toggle
  au!
  au WinEnter,BufEnter * setl stl=%!StatuslineActive()
  au User BufLineUpdated setl stl=%!StatuslineActive()
  au WinLeave,BufLeave * setl stl=%!StatuslineInactive()
augroup end
