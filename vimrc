"""BEGIN VUNDLE INSTALLATION"""
set nocompatible              " be iMproved, required
filetype off                  " required

" Auto-install Vundle
let vundle_installed=0
let vundle_readme=expand('~/.dotfiles-harrison/vim/bundle/Vundle.vim/README.md')
if !filereadable(vundle_readme)
    echo "Installing Vundle..."
    echo ""
    silent !mkdir -p ~/.dotfiles-harrison/vim/bundle
    silent !git clone https://github.com/gmarik/vundle ~/.dotfiles-harrison/vim/bundle/Vundle.vim
    let vundle_installed=1
endif

" set the runtime path to include Vundle and initialize
set rtp+=~/.dotfiles-harrison/vim/bundle/Vundle.vim

call vundle#begin()
    Plugin 'gmarik/Vundle.vim'
    Plugin 'LaTeX-Box-Team/LaTeX-Box'
    Plugin 'tpope/vim-endwise'
call vundle#end()            " required

" Installing vundle plugins
if vundle_installed == 1
    echo "Installing Plugins..."
    echo ""
    :PluginInstall
endif

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
set ignorecase
set smartcase
set incsearch
set formatoptions+=r
set pastetoggle=<F12>
set hlsearch
set wrap

" ****************** SCROLLING *********************  
 
set scrolloff=10        " Number of lines from vertical edge to start scrolling
set sidescrolloff=15    " Number of cols from horizontal edge to start scrolling
set sidescroll=1        " Number of cols to scroll at a time

syntax on
filetype on
filetype indent on

let g:LatexBox_latexmk_options              = "-pdf -pvc"
let g:LatexBox_output_type                  = "pdf"
let g:LatexBox_latexmk_preview_continuously = 1
let g:LatexBox_viewer                       = "zathura"

function! SuperTab()
    if(strpart(getline('.'),col('.')-2,1)=~'^\W\?$')
        return "\<Tab>"
    else
        return "\<C-p>"
    endif
endfunction

imap <Tab> <C-R>=SuperTab()<CR>

" keep search pattern in center of screen
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

" easy split navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" move up/down on wrapped lines !!BEWARE OF MACROS!!
nnoremap j gj
nnoremap k gk

" automatically reload vimrc when it's saved
augroup AutoReloadVimRC
  au!
  au BufWritePost $MYVIMRC so $MYVIMRC
augroup END

" prevent accidental help
noremap <F1> <Esc>

" disable paste mode when leaving insert mode
au InsertLeave * set nopaste

if exists("+undofile")
  " undofile - This allows you to use undos after exiting and restarting
  " This, like swap and backups, uses .vim-undo first, then ~/.vim/undo
  " :help undo-persistence
  " This is only present in 7.3+
  if isdirectory($DOTFILES . '/vim/undo') == 0
    :silent !mkdir -p ~/.vim/undo > /dev/null 2>&1
  endif
  set undodir=./.vim-undo/
  set undodir+=~/.vim/undo/
  set undofile
endif

" more intuitive increment/decrement
nnoremap + <C-a>
nnoremap - <C-x>
