vim9script

# When softwrap happens move by screen line instead of file line
nnoremap j gj
nnoremap k gk

nnoremap <space>j 6j
vnoremap <space>j 6j
nnoremap <space>k 6k
vnoremap <space>k 6k

# alternative to 'packadd nohlsearch'
nnoremap <silent> <esc> :nohls<cr><esc>
