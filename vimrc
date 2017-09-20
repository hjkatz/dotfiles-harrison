" Author: Harrison Katz <hjkatz03@gmail.com>
"
" This is my personal vimrc, feel free to ask me questions about anything that
" you may not understand. Thanks for taking a look!

" NOTE: the below MUST be pointed to the correct installation directory for
" vim extras. If you do not know where this is please contact the author.
let s:vim_directory='~/.dotfiles-harrison/.vim/'

" Plugins first, then settings
" Plugins ------------------------------- {{{

"""BEGIN PLUG INSTALLATION"""
set nocompatible              " required, sets vim to be incompatible with vi
filetype off                  " required, turns off automatic filetype detection for installation

" Vim Plug
source ~/.dotfiles-harrison/plug.vim

call plug#begin(expand(s:vim_directory.'plugged'))
    " better .swp file handling
    Plug 'chrisbra/Recover.vim'

    " more intuitive tab completion
    Plug 'ervandew/supertab'

    " easy alignment
    Plug 'junegunn/vim-easy-align'

    " Text Object Plugins
    " add more builtin text object targets like quotes, tags, braces, etc...
    Plug 'wellle/targets.vim'
    " text object user denifinitions
    Plug 'kana/vim-textobj-user'
    " text objects for ruby blocks with 'r'
    Plug 'tek/vim-textobj-ruby', { 'for': 'ruby' }
    " text object for variable segments with 'v'
    Plug 'Julian/vim-textobj-variable-segment'

    " Filetype Plugins
    Plug 'sheerun/vim-polyglot'
    " adds folding, fancy settings, and more!
    Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }

    " LaTeX Everything
    Plug 'LaTeX-Box-Team/LaTeX-Box', { 'for': 'tex' }

    " syntax and style checking
    Plug 'scrooloose/syntastic'

    " snippets for code insertion
    Plug 'SirVer/ultisnips'

    " auto-upcase sql terms
    Plug 'hjkatz/sql_iabbr.vim', { 'for': 'sql' }

    " extra vim functions to ensure ultisnips and supertab play nice together
    Plug 'tomtom/tlib_vim'

    " comment command with 'gc'
    Plug 'tpope/vim-commentary'

    " add ending control statements in languages like bash, zsh, vimscript, etc...
    Plug 'tpope/vim-endwise'

    " git in vim
    Plug 'tpope/vim-fugitive'

    " repeat everything with '.'
    Plug 'tpope/vim-repeat'

    " act on surrounding items like quotes, tags, braces, etc...
    Plug 'tpope/vim-surround'

    " undo tree viewer and manipulater
    Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }

    " whitespace detection and deletion
    Plug 'ntpeters/vim-better-whitespace'

    " split windows in a spectacular fashion
    Plug 'roman/golden-ratio'

    " asks which file you meant to open
    Plug 'EinfachToll/DidYouMean'
call plug#end()

filetype plugin indent on    " required

" }}}
" Nead Werx Settings {{{

" Test to see if I am on Neadwerx puppet controlled machines or not
let neadwerx_vim=expand('/etc/profile.d/vimrc/neadwerx_vimrc')
if( filereadable(neadwerx_vim) )
    source /etc/profile.d/vimrc/neadwerx_vimrc
    source /etc/profile.d/vimrc/plugins/syntastic.vim
    source /etc/profile.d/vimrc/plugins/easy_align.vim
    source /etc/profile.d/vimrc/plugins/ultisnips.vim
endif

" }}}
" 'Set'ings ---------------------------- {{{
set ts=4                           " tab spacing is 4 spaces
set sw=4                           " shift width is 4 spaces
set expandtab                      " expand all tabs to spaces
set ai                             " autoindent a file based on filetype
set cindent                        " c-style indenting while typing
set background=dark                " our backdrop is dark
set number                         " show line numbers
set ruler                          " show row,col count on bottom bar
set backspace=eol,start,indent     " backspace wraps around indents, start of lines, and end of lines
set ignorecase                     " ignore case when searching
set smartcase                      " ...unless we have atleast 1 capital letter
set incsearch                      " search incrementally
set infercase                      " infer the case of the completion word
set formatoptions=tcqronj          " see :help fo-table for more information
set pastetoggle=<F12>              " sets <F12> to toggle paste mode
set hlsearch                       " highlight search results
set wrap                           " wrap lines
set scrolloff=10                   " leave at least 10 lines at the bottom/top of screen when scrolling
set sidescrolloff=15               " leave at least 15 lines at the right/left of screen when scrolling
set sidescroll=1                   " scroll sidways 1 character at a time
set lazyredraw                     " redraw the screen lazily
" Wildmenu completion {{{

set wildmenu " turn on globing for opening files
set wildmode=list:longest " see :help wildmode for more information

set wildignore+=.hg,.git,.svn                    " Version control
set wildignore+=*.aux,*.out,*.toc                " LaTeX intermediate files
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg   " binary images
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
set wildignore+=*.spl                            " compiled spelling word lists
set wildignore+=*.sw?                            " Vim swap files
set wildignore+=*.luac                           " Lua byte code
set wildignore+=*.pyc                            " Python byte code
set wildignore+=*.orig                           " Merge resolution files

" }}}

" }}}
" Misc --------------------------------- {{{

" turn on syntax coloring and indentation based on the filetype
syntax on
filetype on
filetype indent on

" easy file reloading
nnoremap <F10> :w<CR>:so %<CR>

" <f5> insert date
nnoremap <F5> "=strftime("%c")<CR>P
inoremap <F5> <C-R>=strftime("%c")<CR>

" keep search pattern in center of screen
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

" don't move cursor on '*'
nnoremap <silent> * :let stay_star_view = winsaveview()<cr>*:call winrestview(stay_star_view)<cr>

" move in split windows with ctrl+hjkl
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

" more intuitive increment/decrement with +/-
nnoremap + <C-a>
nnoremap - <C-x>

" Panic Button
nnoremap <f9> mzggg?G`z

" Use sane regexes.
nnoremap / /\v
vnoremap / /\v

" Remap stupid shift letters
command! Q q
command! W w
command! Wq wq

" Leader
let mapleader = ","
let maplocalleader = "\\"

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %

" Disable that fucking 'Entering Ex mode. Type 'visual' to go to Normal mode.'
map Q <Nop>

" Disable vim command history bullshit
map q: <Nop>

" Ctrl-Y by word
inoremap <expr> <c-y> matchstr(getline(line('.')-1), '\%' . virtcol('.') . 'v\%(\k\+\\|.\)')

" }}}
" Plugin Config ------------------------ {{{

" LatexBox ----------------------------- {{{
let g:LatexBox_latexmk_options              = "-pdf -pvc"
let g:LatexBox_output_type                  = "pdf"
let g:LatexBox_latexmk_preview_continuously = 1
let g:LatexBox_viewer                       = "zathura"
let g:LatexBox_Folding                      = 1

" }}}

" EasyAlign {{{

" map the enter key in visual mode to start EasyAlign
vmap <Enter> <Plug>(EasyAlign)

" EasyAlign custom delimiters
"
" s      : align sql centered on the first word, the right aligned along the spacing
" ?      : align param query on ?
" :      : align json on :
" [ or ] : align square brackets on ]
" ( or ) : align parens on )
" { or } : align braces on }
let g:easy_align_delimiters =
    \ {
    \ 's': {
    \       'pattern'      : '\C[a-z]',
    \       'left_margin'  : 1,
    \       'right_margin' : 0,
    \       'align'        : 'r'
    \      },
    \ '?': {
    \       'pattern'      : '[?]',
    \       'left_margin'  : 0,
    \       'right_margin' : 0,
    \       'indentation'  : 's',
    \       'align'        : 'l'
    \      },
    \ ':': {
    \       'pattern'       : ':',
    \       'left_margin'   : 1,
    \       'right_margin'  : 1,
    \       'stick_to_left' : 0
    \      },
    \ '[': {
    \       'pattern'       : ']',
    \       'left_margin'   : 1,
    \       'right_margin'  : 0,
    \       'stick_to_left' : 0
    \      },
    \ ']': {
    \       'pattern'       : ']',
    \       'left_margin'   : 1,
    \       'right_margin'  : 0,
    \       'stick_to_left' : 0
    \      },
    \ '(': {
    \       'pattern'       : ')',
    \       'left_margin'   : 1,
    \       'right_margin'  : 0,
    \       'stick_to_left' : 0
    \      },
    \ ')': {
    \       'pattern'       : ')',
    \       'left_margin'   : 1,
    \       'right_margin'  : 0,
    \       'stick_to_left' : 0
    \      },
    \ '{': {
    \       'pattern'       : '}',
    \       'left_margin'   : 1,
    \       'right_margin'  : 0,
    \       'stick_to_left' : 0
    \      },
    \ '}': {
    \       'pattern'       : '}',
    \       'left_margin'   : 1,
    \       'right_margin'  : 0,
    \       'stick_to_left' : 0
    \      },
    \ '.': {
    \       'pattern'       : '[.]',
    \       'left_margin'   : 1,
    \       'right_margin'  : 1,
    \       'stick_to_left' : 0
    \      }
    \ }

" }}}

" VimMarkdown ----------------------------- {{{

" do not conceal markdown links
let g:vim_markdown_conceal = 0

" }}}

" Undo Tree ----------------------------- {{{

" map undotree to <F3>
nnoremap <F3> :UndotreeToggle<CR>

" window layout with long diff at bottom
let g:undotree_WindowLayout = 2

" give focus to undo tree window on open
let g:undotree_SetFocusWhenToggle = 1

" }}}

" Better Whitespace ----------------------------- {{{

" wrapper function for deleting whitespace while saving cursor position
function! Delete_whitespace()
    " get the current cursor position
    let save_pos = getpos(".")

    " call vim-better-whitespace#:StripWhitespace
    :StripWhitespace

    " return the cursore to the saved position
    call setpos(".", save_pos)
endfunction

" auto-delete whitespace on write
autocmd BufWritePre * call Delete_whitespace()

" }}}

" }}}
" AuGroups ----------------------------- {{{

" Paste mode {{{

" disable paste mode when leaving insert mode
au InsertLeave * set nopaste

" }}}

" Auto reload vimrc {{{

" automatically reload vimrc when it's saved
augroup AutoReloadVimRC
  au!
  au BufWritePost $MYVIMRC so $MYVIMRC
augroup END

" }}}

" Return to line {{{

" return to same line when reopening a file
augroup line_return
    au!
    au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \     execute 'normal! g`"zvzz' |
        \ endif
augroup END

" }}}

" Folding Fix {{{

" Don't update folds in insert mode
aug NoInsertFolding
    au!
    au InsertEnter * let b:oldfdm = &l:fdm | setl fdm=manual
    au InsertLeave * let &l:fdm = b:oldfdm
aug END

" }}}

" Markdown Filetype {{{

aug MarkdownFiletype
    au!
    au BufNewFile,BufFilePre,BufRead *.md set filetype=markdown
aug END

" }}}

" Auto Save and Read {{{

set autoread

augroup autoSaveAndRead
    autocmd!
    autocmd TextChanged,InsertLeave,FocusLost * silent! wall
    autocmd CursorHold * silent! checktime
augroup END

" }}}

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

" Persistant undo {{{

if has('persistent_undo')
  " create undodir
  if isdirectory( s:vim_directory . 'undo' ) == 0
    exec 'silent !mkdir -p ' . s:vim_directory . 'undo > /dev/null 2>&1'
  endif

  let &undodir = expand( s:vim_directory . 'undo' )
  set undofile
endif

" }}}

" }}}
" Folding ------------------------------ {{{

" enable folding and start folds with level-0 unfolded
set foldenable
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
" Filetype-specific -------------------- {{{

" CSS and LessCSS {{{

augroup ft_css
    au!

    au BufNewFile,BufRead *.less setlocal filetype=less

    au Filetype less,css setlocal foldmethod=marker
    au Filetype less,css setlocal foldmarker={,}
    au Filetype less,css setlocal iskeyword+=-

    " Use <localleader>S to sort properties.  Turns this:
    "
    "     p {
    "         width: 200px;
    "         height: 100px;
    "         background: red;
    "
    "         ...
    "     }
    "
    " into this:

    "     p {
    "         background: red;
    "         height: 100px;
    "         width: 200px;
    "
    "         ...
    "     }
    au BufNewFile,BufRead *.less,*.css nnoremap <buffer> <localleader>S ?{<CR>jV/\v^\s*\}?$<CR>k:sort<CR>:noh<CR>

    " Make {<cr> insert a pair of brackets
    au Filetype css inoremap <buffer> {<cr> {}<left><cr><cr><up><space><space><space><space>
    " }fixes syntax highlighting

augroup END

" }}}
" HTML {{{

augroup ft_html
    au!

    au FileType html setlocal ts=2
    au FileType html setlocal sw=2
    au FileType html setlocal expandtab
augroup END

" }}}
" Java {{{

augroup ft_java
    au!

    au FileType java setlocal foldmethod=marker
    au FileType java setlocal foldmarker={,}

    " Make {<cr> insert a pair of brackets
    au Filetype java inoremap <buffer> {<cr> {}<left><cr><cr><up><space><space><space><space>
    " }fixes syntax highlighting
augroup END

" }}}
" Javascript {{{

augroup ft_javascript
    au!

    au FileType javascript setlocal foldmethod=marker
    au FileType javascript setlocal foldmarker={,}

    " Recursive toggle
    au FileType javascript nnoremap <Space> zA
    au FileType javascript vnoremap <Space> zA

    " Prettify a hunk of JSON with <localleader>p
    au FileType javascript nnoremap <buffer> <localleader>p ^vg_:!python -m json.tool<cr>
    au FileType javascript vnoremap <buffer> <localleader>p :!python -m json.tool<cr>

    " Make {<cr> insert a pair of brackets
    au Filetype javascript inoremap <buffer> {<cr> {}<left><cr><cr><up><space><space><space><space>
    " }fixes syntax highlighting
augroup END

" }}}
" JSON {{{

augroup ft_json
    au!

    au FileType json setlocal foldmethod=syntax

    " Recursive toggle
    au FileType json nnoremap <Space> zA
    au FileType json vnoremap <Space> zA

    " Prettify a hunk of JSON with <localleader>p
    au FileType json nnoremap <buffer> <localleader>p ^vg_:!python -m json.tool<cr>
    au FileType json vnoremap <buffer> <localleader>p :!python -m json.tool<cr>

    " Make {<cr> insert a pair of brackets
    au Filetype json inoremap <buffer> {<cr> {}<left><cr><cr><up><space><space><space><space>
    " }fixes syntax highlighting
augroup END

" }}}
" Latex {{{

augroup ft_latex
    au!

    " Folding for latex is handled by latexbox

    au FileType latex setlocal textwidth=80
augroup END

" }}}
" Markdown {{{

augroup ft_markdown
    au!

    au Filetype markdown setlocal tw=80

    au BufNewFile,BufRead *.m*down setlocal filetype=markdown foldlevel=1

    " Use <localleader>1/2/3/4 to add headings.
    au Filetype markdown nnoremap <buffer> <localleader>1 yypVr=:redraw<cr>
    au Filetype markdown nnoremap <buffer> <localleader>2 yypVr-:redraw<cr>
    au Filetype markdown nnoremap <buffer> <localleader>3 mzI###<space><esc>`zllll
    au Filetype markdown nnoremap <buffer> <localleader>4 mzI####<space><esc>`zlllll

    au Filetype markdown nnoremap <buffer> <localleader>p VV:'<,'>!python -m json.tool<cr>
    au Filetype markdown vnoremap <buffer> <localleader>p :!python -m json.tool<cr>
augroup END

" }}}
" Perl {{{

augroup ft_perl
    au!

    au FileType perl setlocal foldmethod=marker
    au FileType perl setlocal foldmarker={,}
    au FileType perl setlocal complete-=i

    " add perl syntax highlighting for the following words
    au FileType perl syn keyword perlStatement any all croak carp cluck confess Readonly

    " Recursive toggle
    au FileType perl nnoremap <Space> zA
    au FileType perl vnoremap <Space> zA

    " Make {<cr> insert a pair of brackets
    au Filetype perl inoremap <buffer> {<cr> {}<left><cr><cr><up><space><space><space><space>
    " }fixes syntax highlighting
augroup END

" }}}
" PHP {{{

augroup ft_php
    au!

    " Make {<cr> insert a pair of brackets
    au Filetype php inoremap <buffer> {<cr> {}<left><cr><cr><up><space><space><space><space>
    " }fixes syntax highlighting

    " set commentary string for php to use hash comments
    au Filetype php setlocal commentstring=#\ %s
augroup END

" }}}
" Python {{{

augroup ft_python
    au!

    au FileType python setlocal define=^\s*\\(def\\\\|class\\)
augroup END

" }}}
" Ruby {{{

augroup ft_ruby
    au!

    au FileType ruby setlocal ts=2
    au FileType ruby setlocal sw=2
    au FileType ruby setlocal expandtab
augroup END

" }}}
" Vim {{{

augroup ft_vim
    au!

    au FileType vim setlocal foldmethod=marker
    au FileType help setlocal textwidth=80
augroup END

" }}}
" XML {{{

augroup ft_xml
    au!

    au FileType xml setlocal foldmethod=manual

    " Use <localleader>f to fold the current tag.
    au FileType xml nnoremap <buffer> <localleader>f Vatzf

    " Indent tag
    au FileType xml nnoremap <buffer> <localleader>= Vat=
augroup END

" }}}
" ZSH {{{

augroup ft_zsh
    au!

    au FileType vim setlocal foldmethod=marker
    au FileType zsh setlocal foldmethod=manual

    " Make {<cr> insert a pair of brackets
    au Filetype zsh inoremap <buffer> {<cr> {}<left><cr><cr><up><space><space><space><space>
    " }fixes syntax highlighting
augroup END

" }}}

" }}}
" Colorscheme {{{

set background=dark
highlight clear

if exists( "syntax_on" )
  syntax reset
endif

set t_Co=256
let g:colors_name = "katz"

hi Cursor                       ctermfg=235  ctermbg=231  cterm=none
hi Visual                       ctermfg=none ctermbg=238  cterm=none
hi CursorLine                   ctermfg=none ctermbg=237  cterm=none
hi CursorColumn                 ctermfg=none ctermbg=237  cterm=none
hi ColorColumn                  ctermfg=none ctermbg=237  cterm=none
hi LineNr                       ctermfg=11   ctermbg=none cterm=none
hi VertSplit                    ctermfg=241  ctermbg=241  cterm=none
hi MatchParen                   ctermfg=141  ctermbg=none cterm=underline
hi StatusLine                   ctermfg=231  ctermbg=241  cterm=bold
hi StatusLineNC                 ctermfg=231  ctermbg=241  cterm=none
hi Pmenu                        ctermfg=none ctermbg=238 cterm=none
hi PmenuSel                     ctermfg=none ctermbg=59   cterm=none
hi IncSearch                    ctermfg=235  ctermbg=186  cterm=none
hi Search                       ctermfg=none ctermbg=236  cterm=inverse,underline
hi Directory                    ctermfg=197  ctermbg=none cterm=none
hi Folded                       ctermfg=14   ctermbg=235  cterm=none
hi SignColumn                   ctermfg=none ctermbg=237  cterm=none
hi Normal                       ctermfg=231  ctermbg=none cterm=none
hi Boolean                      ctermfg=197  ctermbg=none cterm=none
hi Character                    ctermfg=197  ctermbg=none cterm=none
hi Comment                      ctermfg=242  ctermbg=none cterm=none
hi Conditional                  ctermfg=141  ctermbg=none cterm=none
hi Constant                     ctermfg=81 ctermbg=none cterm=none
hi Define                       ctermfg=141  ctermbg=none cterm=none
hi DiffAdd                      ctermfg=231  ctermbg=64   cterm=bold
hi DiffDelete                   ctermfg=88   ctermbg=none cterm=none
hi DiffChange                   ctermfg=none ctermbg=none cterm=none
hi DiffText                     ctermfg=231  ctermbg=24   cterm=bold
hi ErrorMsg                     ctermfg=231  ctermbg=197  cterm=none
hi WarningMsg                   ctermfg=231  ctermbg=197  cterm=none
hi Float                        ctermfg=197  ctermbg=none cterm=none
hi Function                     ctermfg=148  ctermbg=none cterm=none
hi Identifier                   ctermfg=81   ctermbg=none cterm=none
hi Keyword                      ctermfg=141  ctermbg=none cterm=none
hi Label                        ctermfg=186  ctermbg=none cterm=none
hi NonText                      ctermfg=59   ctermbg=none cterm=none
hi Number                       ctermfg=197  ctermbg=none cterm=none
hi Operator                     ctermfg=141  ctermbg=none cterm=none
hi PreProc                      ctermfg=141  ctermbg=none cterm=none
hi Special                      ctermfg=231  ctermbg=none cterm=none
hi SpecialComment               ctermfg=242  ctermbg=none cterm=none
hi SpecialKey                   ctermfg=59   ctermbg=none cterm=none
hi Statement                    ctermfg=141  ctermbg=none cterm=none
hi StorageClass                 ctermfg=81   ctermbg=none cterm=none
hi String                       ctermfg=186  ctermbg=none cterm=none
hi Tag                          ctermfg=141  ctermbg=none cterm=none
hi Title                        ctermfg=231  ctermbg=none cterm=bold
hi Todo                         ctermfg=235   ctermbg=11 cterm=bold
hi Type                         ctermfg=141  ctermbg=none cterm=none
hi Underlined                   ctermfg=none ctermbg=none cterm=underline
hi rubyClass                    ctermfg=141  ctermbg=none cterm=none
hi rubyFunction                 ctermfg=148  ctermbg=none cterm=none
hi rubyInterpolationDelimiter   ctermfg=none ctermbg=none cterm=none
hi rubySymbol                   ctermfg=197  ctermbg=none cterm=none
hi rubyConstant                 ctermfg=81   ctermbg=none cterm=none
hi rubyStringDelimiter          ctermfg=186  ctermbg=none cterm=none
hi rubyBlockParameter           ctermfg=208  ctermbg=none cterm=none
hi rubyInstanceVariable         ctermfg=none ctermbg=none cterm=none
hi rubyInclude                  ctermfg=141  ctermbg=none cterm=none
hi rubyGlobalVariable           ctermfg=none ctermbg=none cterm=none
hi rubyRegexp                   ctermfg=186  ctermbg=none cterm=none
hi rubyRegexpDelimiter          ctermfg=186  ctermbg=none cterm=none
hi rubyEscape                   ctermfg=197  ctermbg=none cterm=none
hi rubyControl                  ctermfg=141  ctermbg=none cterm=none
hi rubyClassVariable            ctermfg=none ctermbg=none cterm=none
hi rubyOperator                 ctermfg=141  ctermbg=none cterm=none
hi rubyException                ctermfg=141  ctermbg=none cterm=none
hi rubyPseudoVariable           ctermfg=none ctermbg=none cterm=none
hi rubyRailsUserClass           ctermfg=81   ctermbg=none cterm=none
hi rubyRailsARAssociationMethod ctermfg=81   ctermbg=none cterm=none
hi rubyRailsARMethod            ctermfg=81   ctermbg=none cterm=none
hi rubyRailsRenderMethod        ctermfg=81   ctermbg=none cterm=none
hi rubyRailsMethod              ctermfg=81   ctermbg=none cterm=none
hi erubyDelimiter               ctermfg=none ctermbg=none cterm=none
hi erubyComment                 ctermfg=95   ctermbg=none cterm=none
hi erubyRailsMethod             ctermfg=81   ctermbg=none cterm=none
hi htmlTag                      ctermfg=148  ctermbg=none cterm=none
hi htmlEndTag                   ctermfg=148  ctermbg=none cterm=none
hi htmlTagName                  ctermfg=none ctermbg=none cterm=none
hi htmlArg                      ctermfg=none ctermbg=none cterm=none
hi htmlSpecialChar              ctermfg=197  ctermbg=none cterm=none
hi javaScriptFunction           ctermfg=81   ctermbg=none cterm=none
hi javaScriptRailsFunction      ctermfg=81   ctermbg=none cterm=none
hi javaScriptBraces             ctermfg=none ctermbg=none cterm=none
hi yamlKey                      ctermfg=141  ctermbg=none cterm=none
hi yamlAnchor                   ctermfg=none ctermbg=none cterm=none
hi yamlAlias                    ctermfg=none ctermbg=none cterm=none
hi yamlDocumentHeader           ctermfg=186  ctermbg=none cterm=none
hi cssURL                       ctermfg=208  ctermbg=none cterm=none
hi cssFunctionName              ctermfg=81   ctermbg=none cterm=none
hi cssColor                     ctermfg=197  ctermbg=none cterm=none
hi cssPseudoClassId             ctermfg=148  ctermbg=none cterm=none
hi cssClassName                 ctermfg=148  ctermbg=none cterm=none
hi cssValueLength               ctermfg=197  ctermbg=none cterm=none
hi cssCommonAttr                ctermfg=81   ctermbg=none cterm=none
hi cssBraces                    ctermfg=none ctermbg=none cterm=none

" }}}
