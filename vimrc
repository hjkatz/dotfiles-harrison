" Vundle ------------------------------- {{{

"""BEGIN VUNDLE INSTALLATION"""
set nocompatible              " be iMproved, required
filetype off                  " required

" Auto-install Vundle
let vundle_installed=0
let vundle_readme=expand('~/.dotfiles-harrison/vim/bundle/Vundle.vim/README.md')
if !filereadable(vundle_readme)
    echo "Installing Vundle..."
    echo ""
    silent! mkdir -p ~/.dotfiles-harrison/vim/bundle
    silent! git clone https://github.com/gmarik/vundle ~/.dotfiles-harrison/vim/bundle/Vundle.vim
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

" }}}

" 'Set'ings ---------------------------- {{{
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
set scrolloff=10
set sidescrolloff=15
set sidescroll=1

" }}}

" Misc --------------------------------- {{{

syntax on
filetype on
filetype indent on

" keep search pattern in center of screen
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

" don't move cursor on '*'
nnoremap <silent> * :let stay_star_view = winsaveview()<cr>*:call winrestview(stay_star_view)<cr>

" easy split navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" move up/down on wrapped lines !!BEWARE OF MACROS!!
nnoremap j gj
nnoremap k gk

" prevent accidental help
noremap <F1> <Esc>
inoremap <F1> <Esc>

" more intuitive increment/decrement
nnoremap + <C-a>
nnoremap - <C-x>

" Panic Button
nnoremap <f9> mzggg?G`z

" Use sane regexes.
nnoremap / /\v
vnoremap / /\v

" }}}

" Plugin Config ------------------------ {{{

" LatexBox ----------------------------- {{{
let g:LatexBox_latexmk_options              = "-pdf -pvc"
let g:LatexBox_output_type                  = "pdf"
let g:LatexBox_latexmk_preview_continuously = 1
let g:LatexBox_viewer                       = "zathura"
let g:LatexBox_Folding                      = 1

" }}}

" }}}

" AuGroups ----------------------------- {{{

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
  set undodir=./.vim-undo//
  set undodir+=~/.vim/undo//
  set undofile
endif

" automatically reload vimrc when it's saved
augroup AutoReloadVimRC
  au!
  au BufWritePost $MYVIMRC so $MYVIMRC
augroup END

" return to same line when reopening a file
augroup line_return
    au!
    au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \     execute 'normal! g`"zvzz' |
        \ endif
augroup END

" }}}

" Functions ---------------------------- {{{

" Pulse Line {{{

function! s:Pulse()
    redir => old_hi
        silent execute 'hi CursorLine'
    redir END
    let old_hi = split(old_hi, '\n')[0]
    let old_hi = substitute(old_hi, 'xxx', '', '')

    let steps = 8
    let width = 1
    let start = width
    let end = steps * width
    let color = 233

    for i in range(start, end, width)
        execute "hi CursorLine ctermbg=" . (color + i)
        redraw
        sleep 6m
    endfor
    for i in range(end, start, -1 * width)
        execute "hi CursorLine ctermbg=" . (color + i)
        redraw
        sleep 6m
    endfor

    execute 'hi ' . old_hi
endfunction
command! -nargs=0 Pulse call s:Pulse()

" }}}

" SuperTab {{{

" personal SuperTab
function! SuperTab()
    if(strpart(getline('.'),col('.')-2,1)=~'^\W\?$')
        return "\<Tab>"
    else
        return "\<C-p>"
    endif
endfunction

imap <Tab> <C-R>=SuperTab()<CR>

" }}}

" }}}

" Folding ------------------------------ {{{

set foldlevelstart=0


" Space to toggle folds.
nnoremap <Space> za
vnoremap <Space> za

" Make zO recursively open whatever fold we're in, even if it's partially open.
nnoremap zO zczO

" 'Focus' the current line.
"
" 1. Close all folds.
" 2. Open just the folds containing the current line.
" 3. Move the line to a little bit (15 lines) above the center of the screen.
" 4. Pulse the cursor line.
"
" This mapping wipes out the z mark
nnoremap <c-z> mzzMzvzz15<c-e>`z:Pulse<cr>

function! MyFoldText() " {{{
    let line = getline(v:foldstart)

    let nucolwidth = &fdc + &number * &numberwidth
    let windowwidth = winwidth(0) - nucolwidth - 3
    let foldedlinecount = v:foldend - v:foldstart

    " expand tabs into spaces
    let onetab = strpart('          ', 0, &tabstop)
    let line = substitute(line, '\t', onetab, 'g')

    let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
    let fillcharcount = windowwidth - len(line) - len(foldedlinecount)
    return line . '…' . repeat(" ",fillcharcount) . foldedlinecount . '…' . ' '
endfunction " }}}
set foldtext=MyFoldText()

" }}}
