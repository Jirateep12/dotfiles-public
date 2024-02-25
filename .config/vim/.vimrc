set viminfo=
set noundofile
set noerrorbells
set clipboard=unnamedplus,unnamed
set guifont=Hack\ Nerd\ Font\ Mono:h14

noremap <silent> x "_x
noremap <silent> + <c-a>
noremap <silent> - <c-x>
noremap <silent> <c-a> gg<s-v>G
noremap <silent> te :tabedit<return>
noremap <silent> tc :tabclose<return>
noremap <silent> <tab> :tabnext<return>
noremap <silent> <s-tab> :tabprevious<return>
noremap <silent> ss :split<return>
noremap <silent> sv :vsplit<return>
noremap <silent> <space> <c-w>w
noremap <silent> sh <c-w>h
noremap <silent> sj <c-w>j
noremap <silent> sk <c-w>k
noremap <silent> sl <c-w>l
noremap <silent> <c-w><left> <c-w><
noremap <silent> <c-w><down> <c-w>-
noremap <silent> <c-w><up> <c-w>+
noremap <silent> <c-w><right> <c-w>>

vnoremap <silent> J :m'>+1<return>gv
vnoremap <silent> K :m'<-2<return>gv

vnoremap <silent> ;uc gU
vnoremap <silent> ;lc gu
vnoremap <silent> ;st :sort i<return>
vnoremap <silent> ;dl :g/^$/d<return>:noh<return>
vnoremap <silent> ;nl :s/\\n/\\r\\r/g<return>:noh<return>
