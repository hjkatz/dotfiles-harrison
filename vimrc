set ts=4 sw=4 expandtab
set ai
set si
set background=dark
set number
set ruler
set backspace=eol,start,indent
set scrolloff=10
set ignorecase
set smartcase
set incsearch
set formatoptions+=r
set pastetoggle=<F12>

syntax on
filetype on
filetype indent on

function! SuperTab()
    if(strpart(getline('.'),col('.')-2,1)=~'^\W\?$')
        return "\<Tab>"
    else
        return "\<C-n>"
    endif
endfunction

imap <Tab> <C-R>=SuperTab()<CR>

nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz
