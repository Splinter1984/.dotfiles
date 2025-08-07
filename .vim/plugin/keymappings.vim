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

# Buffer navigation
nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> [B :bfirst<CR>
nnoremap <silent> ]B :blast<CR>

# Tab navigation
nnoremap <silent> [t :tabprevious<CR>
nnoremap <silent> ]t :tabnext<CR>
nnoremap <silent> [T :tabfirst<CR>
nnoremap <silent> ]T :tablast<CR>

# quickfix list
nnoremap <silent> [c :cprevious<CR>
nnoremap <silent> ]c :cnext<CR>
# nnoremap <silent> [C :cfirst<CR>
# nnoremap <silent> ]C :clast<CR>
nnoremap <silent> [C :colder<CR>
nnoremap <silent> ]C :cnewer<CR>

# location list (buffer local quickfix list)
nnoremap <silent> [l :lprevious<CR>
nnoremap <silent> ]l :lnext<CR>
nnoremap <silent> [L :lfirst<CR>
nnoremap <silent> ]L :llast<CR>

# Map C-/ to do search within visually selected text
# (C-_ produces the same hex code as C-/)
vnoremap <C-_> <Esc>/\%V

# NOTE: Use gp and gP for default purpose
# gp	Just like "p", but leave the cursor just after the new text.
# gP	Just like "P", but leave the cursor just after the new text.

# visually select recent pasted (or typed) text
#   remember `] takes you to end of pasted buffer, or use 'gp' to paste
nnoremap gs `[v`]

nnoremap <leader>vs :set spell!<CR><Bar>:echo "Spell Check: " .. strpart("OffOn", 3 * &spell, 3)<CR>

import autoload 'comment.vim'
nnoremap <silent> <expr> gc comment.Toggle()
xnoremap <silent> <expr> gc comment.Toggle()
nnoremap <silent> <expr> gcc comment.Toggle() .. '_'
