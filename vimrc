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
    " repeat everything with '.'
    Plug 'tpope/vim-repeat'

    " better .swp file handling
    " Plug 'chrisbra/Recover.vim'

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

    " go! must be before vim-polyglot
    Plug 'fatih/vim-go', { 'for': 'go', 'do': ':GoUpdateBinaries' }
    " Filetype Plugins
    Plug 'sheerun/vim-polyglot'
    " adds folding, fancy settings, and more!
    Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
    " ansible
    Plug 'pearofducks/ansible-vim'
    " v
    Plug 'lcolaholicl/vim-v', { 'for': 'v' }
    " jsonnet
    Plug 'google/vim-jsonnet', { 'for': 'jsonnet' }

    " LaTeX Everything
    Plug 'LaTeX-Box-Team/LaTeX-Box', { 'for': 'tex' }

    " syntax and style checking
    " Plug 'scrooloose/syntastic'

    " autocomplete
    Plug 'neoclide/coc.nvim', { 'branch': 'release' }

    " snippets for code insertion
    " Plug 'SirVer/ultisnips'
    " Common snippets for many languages
    Plug 'honza/vim-snippets'
    " Golang Ginkgo snippets
    Plug 'trayo/vim-ginkgo-snippets', { 'for': 'go' }

    " auto-upcase sql terms
    Plug 'hjkatz/sql_iabbr.vim', { 'for': 'sql' }

    " comment command with 'gc'
    Plug 'tpope/vim-commentary'

    " add ending control statements in languages like bash, zsh, vimscript, etc...
    Plug 'tpope/vim-endwise'

    " Abolish
    "  - Abbreviations: :Abolish {despa,sepe}rat{e,es,ed,ing,ely,ion,ions,or} {despe,sepa}rat{}
    "  - Sbustitution: :%Subvert (or :%S)  :%S/facilit{y,ies}/building{,s}/g
    "  - Coercion: fooBar -> foo_bar --> `crs` (coerce to snake_case)
    "    - snake_case `crs`
    "    - MixedCase `crm`
    "    - camelCase `crc`
    "    - UPPER_CASE `cru`
    "    - dash-case `cr-`
    "    - dot.case `cr.`
    "    - space case `cr<space>`
    "    - Title Case `crt`
    Plug 'tpope/vim-abolish'

    " git in vim
    Plug 'tpope/vim-fugitive'
    Plug 'tommcdo/vim-fubitive'
    Plug 'tpope/vim-rhubarb'

    " act on surrounding items like quotes, tags, braces, etc...
    Plug 'tpope/vim-surround'

    " undo tree viewer and manipulater
    Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }

    " whitespace detection and deletion
    Plug 'ntpeters/vim-better-whitespace'

    " split windows in a spectacular fashion
    " Plug 'roman/golden-ratio'

    " asks which file you meant to open
    Plug 'EinfachToll/DidYouMean'

    " quickfix/location list taming
    Plug 'romainl/vim-qf'

    " git gutter
    Plug 'airblade/vim-gitgutter'

    " tagbar
    Plug 'majutsushi/tagbar'
call plug#end()

filetype plugin indent on    " required

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
set autowrite                      " autowrite on things like :next, :prev, :etc...
set lazyredraw                     " redraw the screen lazily
set updatetime=300                 " set vim's updatetime
" Wildmenu completion {{{

set wildmenu " turn on globing for opening files
set wildmode=longest:full,full " see :help wildmode for more information

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

" substring {{{
" from https://gist.github.com/tyru/984296
" Substitute a:from => a:to by string.
" To substitute by pattern, use substitute() instead.
function! s:substring(str, from, to)
  if a:str ==# '' || a:from ==# ''
      return a:str
  endif
  let str = a:str
  let idx = stridx(str, a:from)
  while idx !=# -1
      let left  = idx ==# 0 ? '' : str[: idx - 1]
      let right = str[idx + strlen(a:from) :]
      let str = left . a:to . right
      let idx = stridx(str, a:from)
  endwhile
  return str
endfunction

" }}}

" chomp {{{
function! s:chomp(string)
  return substitute(a:string, '\n\+$', '', '')
endfunction

" }}}

" check_back_space {{{

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" }}}

" }}}
" Misc --------------------------------- {{{

" turn on syntax coloring and indentation based on the filetype
syntax on
filetype on
filetype indent on

" easy file reloading
" nnoremap <F10> :w<CR>:so %<CR>

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" show the syntax highlighting group of the object under the cursor
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" <F5> insert date
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
let mapleader = ','
let maplocalleader = ","

" Prettify a hunk of JSON with <localleader>j
nnoremap <buffer> <localleader>j ^vg_:!python -m json.tool<cr>
vnoremap <buffer> <localleader>j :!python -m json.tool<cr>

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %

" because saving the ';' file is so useful...
cmap w; wq

" I don't think I ever want to use ;
cmap ; q
" except for sometimes
cnoremap :: ;

" Disable that fucking 'Entering Ex mode. Type 'visual' to go to Normal mode.'
map Q <Nop>

" Disable vim command history bullshit
map q: <Nop>

" Ctrl-Y by word
inoremap <expr> <c-y> matchstr(getline(line('.')-1), '\%' . virtcol('.') . 'v\%(\k\+\\|.\)')

" }}}
" Plugin Config ------------------------ {{{

" golden ratio ----------------------------- {{{

" don't resize nonmodifiable windows like quickfix/location/tag lists
" let g:golden_ratio_exclude_nonmodifiable = 1

" }}}

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

" [See: https://github.com/plasticboy/vim-markdown/issues/414]
let g:vim_markdown_folding_style_pythonic = 1

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

" Ultisnips -------------------------- {{{

" let g:UltiSnipsExpandTrigger="<tab>"
" let g:UltiSnipsJumpForwardTrigger="<tab>"
" let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
" let g:UltiSnipsSnippetDirectories=[$HOME.'/.dotfiles-harrison/UltiSnips', 'UltiSnips']

" }}}

" vim-qf ----------------------------- {{{

" Mappings for location list movement
nmap <Home> <Plug>(qf_qf_previous)
nmap <End>  <Plug>(qf_qf_next)

nmap <C-Home> <Plug>(qf_loc_previous)
nmap <C-End>  <Plug>(qf_loc_next)

nmap <F5> <Plug>(qf_qf_toggle)

let g:qf_auto_resize = 0
let g:qf_save_win_view = 1

" }}}

" vim-go ----------------------------- {{{

" disable vim-go :GoDef short cut (gd)
" this is handled by LanguageClient [LC]
let g:go_def_mapping_enabled = 0

" }}}

" vim-fubitive ----------------------------- {{{

" configure bitbucket for code.squarespace.net
let g:fubitive_domain_pattern = 'code\.squarespace\.net'

" }}}

" Syntastic ----------------------------- {{{

" Only use quickfix lists
let g:syntastic_use_quickfix_lists = 1

let g:syntastic_mode_map = {
    \ "mode": "active",
    \ "passive_filetypes": ["go", "python", "ansible"]
    \}

" }}}

" CoC ----------------------------- {{{

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
" inoremap <expr> <cr> pumvisible() ? '\<C-y>' : '\<C-g>u\<CR>'

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" " Mappings for jump to definition
nmap <C-n> gd
nmap <C-t> <C-o>

" Remap for rename current word
nmap <leader>r <Plug>(coc-rename)

inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

let g:coc_snippet_next = '<tab>'

" }}}

" tagbar ----------------------------- {{{

nnoremap <silent> <F2> :TagbarToggle<CR>

let g:tagbar_map_togglefold = '<Space>'
let g:tagbar_autofocus = 1

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
" Coffeescript {{{

augroup ft_coffee
    au!

    au FileType coffee setlocal ts=2
    au FileType coffee setlocal sw=2
    au FileType coffee setlocal expandtab

    au FileType coffee setlocal foldmethod=marker
    au FileType coffee setlocal foldmarker={,}

    " Recursive toggle
    au FileType coffee nnoremap <Space> zA
    au FileType coffee vnoremap <Space> zA

    " Make {<cr> insert a pair of brackets
    au Filetype coffee inoremap <buffer> {<cr> {}<left><cr><cr><up><space><space><space><space>
    " }fixes syntax highlighting
augroup END

" }}}
" Go {{{

augroup ft_go
    au!

    " allow deoplete to complete via the omnifunc and vim-go
    " call deoplete#custom#option('omni_patterns', { 'go': '[^. *\t]\.\w*' })

    " turn on folding
    au FileType go setlocal foldmethod=syntax

    " Recursive toggle
    au FileType go nnoremap <Space> zA
    au FileType go vnoremap <Space> zA

    " use experimental mode for go fmt
    au FileType go let g:go_fmt_experimental = 1
    au FileType go let g:go_fmt_command = 'goimports'
    au FileType go let g:go_metalinter_autosave = 0
    au FileType go let g:go_metalinter_command = '--tests --vendor --exclude=vendor
                                                \ --enable vet
                                                \ --enable deadcode
                                                \ --enable varcheck
                                                \ --enable structcheck
                                                \ --enable errcheck
                                                \ --enable dupl
                                                \ --enable ineffassign
                                                \ --enable goconst
                                                \ --enable golint
                                                \'
    au FileType go let g:go_metalinter_enabled = [ 'vet', 'deadcode', 'varcheck', 'structcheck', 'dupl', 'ineffassign', 'goconst', 'golint', 'errcheck' ]

    " add some missing Plug mappings
    nnoremap <silent> <Plug>(go-toggle-same-ids) :<C-u>call go#guru#ToggleSameIds()<CR>

    " automatic stuff
    au FileType go let g:go_auto_type_info = 1
    au FileType go let g:go_auto_sameids = 0
    au FileType go let g:go_fmt_autosave = 1
    au FileType go let g:go_updatetime = 800 "ms

    " adjust the highlighting
    au FileType go let g:go_highlight_build_constraints = 1
    au FileType go let g:go_highlight_array_whitespace_error = 1
    au FileType go let g:go_highlight_space_tab_error = 1
    au FileType go let g:go_highlight_operators = 1
    au FileType go let g:go_highlight_functions = 1
    au FileType go let g:go_highlight_function_arguments = 1
    au FileType go let g:go_highlight_function_calls = 1
    au FileType go let g:go_highlight_types = 1
    au FileType go let g:go_highlight_extra_types = 1
    au FileType go let g:go_highlight_fields = 1
    au FileType go let g:go_highlight_string_spellcheck = 1
    au FileType go let g:go_highlight_format_strings = 1
    au FileType go let g:go_highlight_variable_declarations = 1
    au FileType go let g:go_highlight_variable_assignments = 1

    " Alternate Alternate commands
    au Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
    au Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
    au Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
    au Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')

    " run :GoBuild or :GoTestCompile based on the go file
    function! s:build_go_files()
      let l:file = expand('%')
      if l:file =~# '^\f\+_test\.go$'
        call go#test#Test(0, 1)
      elseif l:file =~# '^\f\+\.go$'
        call go#cmd#Build(0)
      endif
    endfunction

    " set the vim-go guru scope from the git root
    function! s:go_guru_scope_from_git_root()
    " chomp because get rev-parse returns line with newline at the end
      return s:chomp(s:substring(system("git rev-parse --show-toplevel"),$GOPATH . "/src/","")) . "/..."
    endfunction

    " do this everytime we open a go file
    au FileType go silent exe "GoGuruScope " . s:go_guru_scope_from_git_root()

    " setup some leaders
    au FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
    au FileType go nmap <F4> <Plug>(go-run)
    au FileType go nmap <Leader>t <Plug>(go-test)
    au FileType go nmap <Leader>tf <Plug>(go-test-func)
    au FileType go nmap <Leader>i <Plug>(go-imports)
    au FileType go nmap <Leader><space> <Plug>(go-toggle-same-ids)
    au FileType go nmap <Leader>a :call go#alternate#Switch('', 'edit')<CR>
    au FileType go nmap <Leader>s :call go#alternate#Switch('', 'split')<CR>
    au FileType go nmap <Leader>v :call go#alternate#Switch('', 'vsplit')<CR>
    au FileType go nmap <Leader>d <Plug>(go-doc)
    au FileType go nmap <Leader>c zR<Plug>(go-coverage-toggle)
    au FileType go nmap <Leader>r <Plug>(go-rename)
    au FileType go nmap <F6> zR<Plug>(go-metalinter)
    au FileType go nmap <F7> zR<Plug>(go-coverage-toggle)
    " au FileType go nmap <F8> zR<Plug>(go-breakpoint-toggle)
    au FileType go nnoremap <F8> Ortime.Breakpoint()<esc>/import<cr>Oimport rtime "runtime"<esc><c-o>:w<cr>

    " abbreviations
    au FileType go iabbrev === :=
    au FileType go iabbrev !! !=
    au FileType go iabbrev importlogrus log "github.com/sirupsen/logrus"
    au FileType go iabbrev importlog log "github.com/sirupsen/logrus"
    au FileType go iabbrev importspew "github.com/davecgh/go-spew/spew"
    au FileType go iabbrev importmetav1 metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"

    " only use the quicklist
    au FileType go let g:go_list_type = 'quickfix'
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
" Helm (yaml) {{{

augroup ft_helm
    au!

    " use # for comments instead of default /* ... */
    au FileType helm setlocal commentstring=#\ %s
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

    " Make {<cr> insert a pair of brackets
    au Filetype json inoremap <buffer> {<cr> {}<left><cr><cr><up><space><space><space><space>
    " }fixes syntax highlighting
augroup END

" }}}
" jsonnet {{{

augroup ft_jsonnet
    au!

    au FileType jsonnet setlocal ts=2
    au FileType jsonnet setlocal sw=2
    au FileType jsonnet setlocal expandtab

    au FileType jsonnet setlocal foldmethod=indent

    " Recursive toggle
    au FileType jsonnet nnoremap <Space> zA
    au FileType jsonnet vnoremap <Space> zA

    " no c-style indenting because it messes up the indenting
    au FileType jsonnet setlocal nocindent

    " use # for comments instead of default //
    au FileType jsonnet setlocal commentstring=#\ %s

    " Make {<cr> insert a pair of brackets
    au Filetype jsonnet inoremap <buffer> {<cr> {}<left><cr><cr><up><space><space><space><space>
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
hi goStatement ctermfg=200
hi goLabel ctermfg=141
hi goBuiltins ctermfg=200
" hi goLabel ctermfg=200
hi goFunctionCall ctermfg=148

" }}}
