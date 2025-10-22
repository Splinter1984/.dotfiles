vim9script

export def Blame(..args: list<string>): string
  var fnam = expand('%')
  var lnum = line('.=')

  var comd = printf("git blame %s | grep '\s%d)'", fnam, lnum)

  return system(comd)
enddef
