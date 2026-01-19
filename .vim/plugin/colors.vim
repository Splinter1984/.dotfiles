vim9script

# Palette: {{{
# ----------------------------------------------------------------------------
# Really usefull to keep all needed colors in one place.

var palette = {'cterm': {}}

palette.cterm.backgd     = "234"
palette.cterm.foregd     = "255"
palette.cterm.fg1        = "240"
palette.cterm.window     = "237"
palette.cterm.fg2        = "250"
palette.cterm.line       = "234"
palette.cterm.comment    = "243"
palette.cterm.red        = "1"
palette.cterm.orange     = "214"
palette.cterm.orange1    = "208"
palette.cterm.yellow     = "3"
palette.cterm.green      = "2"
palette.cterm.green1     = "10"
palette.cterm.aqua       = "6"
palette.cterm.blue       = "4"
palette.cterm.purple     = "5"
palette.cterm.addbg      = "2"
palette.cterm.addfg      = "2"
palette.cterm.changebg   = "5"
palette.cterm.changefg   = "5"
palette.cterm.delbg      = "1"
palette.cterm.delfg      = "1"
palette.cterm.textfg     = "none"
palette.cterm.darkblue   = "25"
palette.cterm.darkcyan   = "38"
palette.cterm.darkred    = "none"
palette.cterm.darkpurple = "13"

# }}}
# Formatting: {{{
# ----------------------------------------------------------------------------

var n      = "None"
var c      = ",undercurl"
var r      = ",reverse"
var s      = ",standout"
var b      = ",bold"
var u      = ",underline"
var i      = ",italic"

# }}}
# Highlighting Primitives: {{{
# ----------------------------------------------------------------------------

def BuildPrim(hi_elem: string, field: string)
  var vname = hi_elem .. "_" .. field # <bg/fg>_<field>
  # var gui_assign = "gui".a:hi_elem."=".palette.gui[a:field][style] # guibg=...
  var cterm_assign = "cterm" .. hi_elem .. "=" .. palette.cterm[field] # ctermbg=...
  exe "var  " .. vname .. " = ' " .. cterm_assign .. "'"
enddef

var bg_none = $'ctermbg={n}'
BuildPrim('bg', 'foregd')
BuildPrim('bg', 'fg1')
BuildPrim('bg', 'backgd')
BuildPrim('bg', 'fg2')
BuildPrim('bg', 'line')
BuildPrim('bg', 'comment')
BuildPrim('bg', 'red')
BuildPrim('bg', 'orange')
BuildPrim('bg', 'orange1')
BuildPrim('bg', 'yellow')
BuildPrim('bg', 'green')
BuildPrim('bg', 'green1')
BuildPrim('bg', 'aqua')
BuildPrim('bg', 'blue')
BuildPrim('bg', 'purple')
BuildPrim('bg', 'window')
BuildPrim('bg', 'addbg')
BuildPrim('bg', 'changebg')
BuildPrim('bg', 'delbg')
BuildPrim('bg', 'darkblue')
BuildPrim('bg', 'darkcyan')
BuildPrim('bg', 'darkred')
BuildPrim('bg', 'darkpurple')

var fg_none = $'ctermfg={n}'
BuildPrim('fg', 'foregd')
BuildPrim('fg', 'fg1')
BuildPrim('fg', 'backgd')
BuildPrim('fg', 'fg2')
BuildPrim('fg', 'line')
BuildPrim('fg', 'comment')
BuildPrim('fg', 'red')
BuildPrim('fg', 'orange')
BuildPrim('fg', 'orange1')
BuildPrim('fg', 'yellow')
BuildPrim('fg', 'green')
BuildPrim('fg', 'green1')
BuildPrim('fg', 'aqua')
BuildPrim('fg', 'blue')
BuildPrim('fg', 'purple')
BuildPrim('fg', 'window')
BuildPrim('fg', 'addfg')
BuildPrim('fg', 'changefg')
BuildPrim('fg', 'delfg')
BuildPrim('fg', 'textfg')
BuildPrim('fg', 'darkblue')
BuildPrim('fg', 'darkcyan')
BuildPrim('fg', 'darkred')
BuildPrim('fg', 'darkpurple')

exe $"var fmt_none = ' gui={n}              cterm={n}           term={n}      '"
exe $"var fmt_bold = ' gui={n}{b}           cterm={n}{b}        term={n}{b}   '"
exe $"var fmt_bldi = ' gui={n}{b}           cterm={n}{b}        term={n}{b}   '"
exe $"var fmt_undr = ' gui={n}{u}           cterm={n}{u}        term={n}{u}   '"
exe $"var fmt_undb = ' gui={n}{u}{b}        cterm={n}{u}{b}     term={n}{u}{b}'"
exe $"var fmt_undi = ' gui={n}{u}{i}        cterm={n}{u}{i}     term={n}{u}{i}'"
exe $"var fmt_curl = ' gui={n}{c}           cterm={n}{c}        term={n}{c}   '"
exe $"var fmt_ital = ' gui={n}{i}           cterm={n}{i}        term={n}{i}   '"
exe $"var fmt_stnd = ' gui={n}{s}           cterm={n}{s}        term={n}{s}   '"
exe $"var fmt_revr = ' gui={n}{r}           cterm={n}{r}        term={n}{r}   '"
exe $"var fmt_revb = ' gui={n}{r}{b}        cterm={n}{r}{b}     term={n}{r}{b}'"

# }}}
# Vim Highlighting: {{{
# ----------------------------------------------------------------------------

def ColorCorrect()

  exe $"hi! Normal                    {fg_none}       {bg_none}      {fmt_none}"

  exe $"hi! ColorColumn               {fg_none}       {bg_backgd}    {fmt_none}"
  exe $"hi! Conceal                   {fg_fg1}        {bg_none}      {fmt_none}"
  # Cursor
  # CursorIM
  exe $"hi! CursorColumn              {fg_none}       {bg_line}      {fmt_none}"
  exe $"hi! CursorLine                {fg_none}       {bg_line}      {fmt_none}"
  exe $"hi! CursorLineNr              {fg_yellow}     {bg_line}      {fmt_none}"
  exe $"hi! CursorLineSign            {fg_none}       {bg_line}      {fmt_none}"
  # Directory
  exe $"hi! DiffAdd                   {fg_addfg}      {bg_none}      {fmt_none}"
  exe $"hi! DiffChange                {fg_changefg}   {bg_none}      {fmt_none}"
  exe $"hi! DiffDelete                {fg_delfg}      {bg_none}      {fmt_none}"
  exe $"hi! DiffText                  {fg_none}       {bg_none}      {fmt_none}"
  # ErrorMsg
  # VertSplit
  # Folded
  # FoldColumn
  exe $"hi! SignColumn                {fg_none}        {bg_none}     {fmt_none}"

## GitGutter: {{{

  exe $"hi! GitGutterAdd              {fg_addfg}       {bg_none}     {fmt_none}"
  exe $"hi! GitGutterChange           {fg_changefg}    {bg_none}     {fmt_none}"
  exe $"hi! GitGutterDelete           {fg_delfg}       {bg_none}     {fmt_none}"
  exe $"hi! GitGutterChangeDelete     {fg_delfg}       {bg_none}     {fmt_none}"

  exe $"hi! GitGutterAddLine          {fg_addfg}       {bg_none}     {fmt_none}"
  exe $"hi! GitGutterChangeLine       {fg_changefg}    {bg_none}     {fmt_none}"
  exe $"hi! GitGutterDeleteLine       {fg_delfg}       {bg_none}     {fmt_none}"
  exe $"hi! GitGutterChangeDeleteLine {fg_delfg}       {bg_none}     {fmt_none}"

  exe $"hi! GitGutterAddIntraLine     {fg_addfg}       {bg_none}     {fmt_none}"
  exe $"hi! GitGutterDeleteIntraLine  {fg_delfg}       {bg_none}     {fmt_none}"

## }}}
## Git: {{{
  exe $"hi! diffAdded                 {fg_addfg}       {bg_none}     {fmt_none}"
  exe $"hi! diffChangeed              {fg_changefg}    {bg_none}     {fmt_none}"
  exe $"hi! diffRemoved               {fg_delfg}       {bg_none}     {fmt_none}"
  exe $"hi! diffText                  {fg_none}        {bg_none}     {fmt_none}"

  exe $"hi! diffFile                  {fg_none}        {bg_none}     {fmt_bold}"
  exe $"hi! diffIndexLine             {fg_none}        {bg_none}     {fmt_bold}"
  exe $"hi! diffOldFile               {fg_none}        {bg_none}     {fmt_bold}"
  exe $"hi! diffNewFile               {fg_none}        {bg_none}     {fmt_bold}"

  exe $"hi! diffLine                  {fg_blue}        {bg_none}     {fmt_none}"
  exe $"hi! diffSubname               {fg_none}        {bg_none}     {fmt_none}"

## }}}
## VimSuggest: {{{

  exe $"hi! VimSuggestMute            {fg_none}        {bg_none}     {fmt_none}"
  exe $"hi! VimSuggestMatch           {fg_yellow}      {bg_window}   {fmt_none}"
  exe $"hi! VimSuggestSel             {fg_none}        {bg_fg1}      {fmt_bold}"

## }}}
## LSP: {{{

  exe $"hi! LspDiagSignErrorText      {fg_red}         {bg_none}     {fmt_none}"
  exe $"hi! LspDiagSignWarningText    {fg_yellow}      {bg_none}     {fmt_none}"
  exe $"hi! LspDiagSignHintText       {fg_comment}     {bg_none}     {fmt_none}"
  exe $"hi! LspDiagSignInfoText       {fg_fg1}         {bg_none}     {fmt_none}"

  exe $"hi! LspDiagVirtualTextError   {fg_red}         {bg_none}     {fmt_none}"
  exe $"hi! LspDiagVirtualTextWarning {fg_yellow}      {bg_none}     {fmt_none}"
  exe $"hi! LspDiagVirtualTextHint    {fg_comment}     {bg_none}     {fmt_none}"
  exe $"hi! LspDiagVirtualTextInfo    {fg_fg1}         {bg_none}     {fmt_none}"

## }}}
## GitConflictMarker: {{{

  # exe $"hi! ConflictMarkerBegin       {fg_none}        {bg_none}     {fmt_bold}"
  # exe $"hi! ConflictMarkerOurs        {fg_none}        {bg_none}     {fmt_none}"
  # exe $"hi! ConflictMarkerTheirs      {fg_none}        {bg_none}     {fmt_none}"
  # exe $"hi! ConflictMarkerEnd         {fg_none}        {bg_none}     {fmt_bold}"
  # exe $"hi! ConflictMarkerCommonAncestorsHunk
  #       \                             {fg_none}        {bg_none}     {fmt_bold}"

## }}}
  # Incsearch
  exe $"hi! LineNr                    {fg_fg1}         {bg_none}     {fmt_none}"
  exe $"hi! Visual                    {fg_none}        {bg_none}     {fmt_revr}"
  exe $"hi! StatusLine                {fg_none}        {bg_none}     {fmt_none}"
  exe $"hi! StatusLineNC              {fg_fg1}         {bg_none}     {fmt_none}"
  exe $"hi! MatchParen                {fg_foregd}      {bg_none}     {fmt_revr}"

  exe $"hi! Todo                      {fg_comment}     {bg_none}     {fmt_revb}"
## SyntaxMatch: {{{

  exe $"hi! TODO                      {fg_blue}        {bg_none}     {fmt_revb}"
  exe $"hi! FIXME                     {fg_red}         {bg_none}     {fmt_revb}"
  exe $"hi! NOTE                      {fg_fg1}         {bg_none}     {fmt_revb}"

## }}}

  exe $"hi! Error                     {fg_red}         {bg_none}     {fmt_revr}"
  exe $"hi! Pmenu                     {fg_none}        {bg_window}   {fmt_none}"
  exe $"hi! PmenuMatch                {fg_yellow}      {bg_window}   {fmt_none}"
  exe $"hi! PmenuSel                  {fg_none}        {bg_fg1}      {fmt_bold}"
  exe $"hi! PmenuThumb                {fg_comment}     {bg_comment}  {fmt_none}"
  exe $"hi! PmenuSbar                 {fg_line}        {bg_line}     {fmt_none}"

  exe $"hi! Search                    {fg_backgd}      {bg_foregd}   {fmt_none}"
  #exe $"hi! IncSearch                {fg_orange}      {bg_none}     {fmt_revr}"
  exe $"hi! CurSearch                 {fg_yellow}      {bg_none}     {fmt_revr}"

## StatusLineCustom: {{{

  exe $"hi! StatLineSP                {fg_green}       {bg_none}     {fmt_none}"
  exe $"hi! StatLineSP1               {fg_yellow}      {bg_none}     {fmt_none}"
  exe $"hi! StatLineSD                {fg_blue}        {bg_none}     {fmt_none}"

## }}}

  exe $"hi! Comment                   {fg_comment}     {bg_none}     {fmt_none}"
  exe $"hi! NonText                   {fg_none}        {bg_none}     {fmt_none}"
  exe $"hi! EndOfBuffer               {fg_none}        {bg_none}     {fmt_none}"
  exe $"hi! Constant                  {fg_blue}        {bg_none}     {fmt_none}"
  exe $"hi! String                    {fg_aqua}        {bg_none}     {fmt_none}"
  exe $"hi! Character                 {fg_aqua}        {bg_none}     {fmt_none}"
  exe $"hi! Boolean                   {fg_purple}      {bg_none}     {fmt_none}"
  exe $"hi! Identifier                {fg_blue}        {bg_none}     {fmt_none}"
  exe $"hi! Function                  {fg_green}       {bg_none}     {fmt_none}"
  exe $"hi! VertSplit                 {fg_none}        {bg_none}     {fmt_none}"
  exe $"hi! NonText                   {fg_none}        {bg_none}     {fmt_none}"
  exe $"hi! SpecialKey                {fg_fg1}         {bg_none}     {fmt_none}"

  exe $"hi! Statement                 {fg_red}         {bg_none}     {fmt_none}"
  exe $"hi! PreProc                   {fg_green}       {bg_none}     {fmt_none}"
  exe $"hi! Special                   {fg_green}       {bg_none}     {fmt_none}"
  exe $"hi! SpecialChar               {fg_purple}      {bg_none}     {fmt_none}"
  exe $"hi! Type                      {fg_yellow}      {bg_none}     {fmt_none}"

  exe $"hi! MemberAccess              {fg_none}        {bg_none}     {fmt_none}"

  exe $"hi! SpellBad                  {fg_none}        {bg_none}     {fmt_undr}" # ctermul={palette.cterm.red}"
  exe $"hi! SpellCap                  {fg_none}        {bg_none}     {fmt_undr}" # ctermul={palette.cterm.yellow}"
  exe $"hi! SpellLocal                {fg_none}        {bg_none}     {fmt_undr}" # ctermul={palette.cterm.comment}"
  exe $"hi! SpellRare                 {fg_none}        {bg_none}     {fmt_undr}" # ctermul={palette.cterm.foregd}"

  exe $"hi! Folded                    {fg_blue}        {bg_none}     {fmt_none}"
  exe $"hi! FoldColumn                {fg_none}        {bg_none}     {fmt_none}"

  exe $"hi! TabLine                   {fg_fg1}         {bg_none}     {fmt_none}"
  exe $"hi! TabLineFill               {fg_none}        {bg_none}     {fmt_none}"

enddef

# autocmd BufRead,BufNewFile * syn match parens /[(){}]/ | exe $"hi! parens {fg_orange} {bg_none} {fmt_none}"
autocmd VimEnter,WinEnter * call ColorCorrect()

# Following should occur after setting colorscheme.
# highlight! TrailingWhitespace ctermfg=8 cterm=reverse
exe $"hi! TrailingWhitespace          {fg_comment}     {bg_none}     {fmt_none}"
match TrailingWhitespace /\s\+\%#\@<!$/

autocmd Syntax * syn match TODO   /\v\_.<TODO/hs=s+1  containedin=.*Comment
autocmd Syntax * syn match FIXME  /\v\_.<FIXME/hs=s+1 containedin=.*Comment
autocmd Syntax * syn match NOTE   /\v\_.<NOTE/hs=s+1  containedin=.*Comment
