vim9script

# When softwrap happens move by screen line instead of file line
nnoremap j gj
nnoremap k gk

nnoremap <leader>j 6j
vnoremap <leader>j 6j
nnoremap <leader>k 6k
vnoremap <leader>k 6k

# alternative to 'packadd nohlsearch'
nnoremap <silent> <esc> :nohls<cr><esc>
