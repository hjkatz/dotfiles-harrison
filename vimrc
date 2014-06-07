"""BEGIN VUNDLE INSTALLATION"""
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.dotfiles-harrison/vim/bundle/Vundle.vim
call vundle#begin()
    Plugin 'gmarik/Vundle.vim'
    Bundle 'LaTeX-Box-Team/LaTeX-Box'
call vundle#end()            " required
filetype plugin indent on    " required
"""END VUNDLE INSTALLATION"""

set ts=4
set sw=4
set expandtab
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
set hlsearch
set wrap

syntax on
filetype on
filetype indent on

let g:LatexBox_latexmk_options              = "-pdf -pvc"
let g:LatexBox_output_type                  = "pdf"
let g:LatexBox_latexmk_preview_continuously = 1
let g:LatexBox_viewer                       = "evince"

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
