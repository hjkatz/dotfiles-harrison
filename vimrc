" Legacy vimrc - now sources init.lua for Neovim compatibility
" Author: Harrison Katz <hjkatz03@gmail.com>
"
" This vimrc now acts as a bridge to the new init.lua configuration
" All actual configuration has been moved to init.lua

" Check if we're running Neovim
if has('nvim')
    " We're in Neovim - source the Lua config
    lua dofile(vim.fn.expand('~/.dotfiles-harrison/init.lua'))
else
    " We're in regular Vim - provide minimal fallback configuration
    echo "Warning: This dotfiles setup is now optimized for Neovim."
    echo "Please install Neovim for the full experience."
    echo "Falling back to basic Vim configuration..."

    " Basic settings for regular Vim
    set nocompatible
    set number
    set ruler
    set background=dark
    set tabstop=4
    set shiftwidth=4
    set expandtab
    set autoindent
    set ignorecase
    set smartcase
    set incsearch
    set hlsearch
    set backspace=eol,start,indent
    set scrolloff=10
    set sidescrolloff=15
    set sidescroll=1
    set autowrite
    set lazyredraw
    set mouse=

    " Leader key
    let mapleader = ','
    let maplocalleader = ','

    " Basic key mappings
    nnoremap j gj
    nnoremap k gk
    nnoremap <C-h> <C-w>h
    nnoremap <C-j> <C-w>j
    nnoremap <C-k> <C-w>k
    nnoremap <C-l> <C-w>l
    nnoremap + <C-a>
    nnoremap - <C-x>
    nnoremap n nzz
    nnoremap N Nzz
    nnoremap * *zz
    nnoremap # #zz

    " Basic folding
    set foldmethod=indent
    set foldenable
    set foldlevelstart=0
    nnoremap <Space> za

    " Prevent accidental help
    noremap <F1> <Esc>
    inoremap <F1> <Esc>

    " Disable Ex mode
    map Q <Nop>
    map q: <Nop>

    " Basic commands
    command! Q q
    command! W w
    command! Wq wq

    echo "Basic Vim configuration loaded. Consider switching to Neovim!"
endif
