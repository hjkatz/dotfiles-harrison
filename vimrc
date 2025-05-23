" Author: Harrison Katz <hjkatz03@gmail.com>
"
" This is my personal vimrc, feel free to ask me questions about anything that
" you may not understand. Thanks for taking a look!

" NOTE: the below MUST be pointed to the correct installation directory for
" vim extras. If you do not know where this is please contact the author.
let g:dotfiles_vim_dir=$HOME.'/.dotfiles-harrison/.vim/'

" lua config in vim, see: https://herrbischoff.com/2022/07/neovim-using-init-vim-and-init-lua-concurrently/
" lua <<EOF
"    <lua code>
" EOF

" Note: These must be installed on the system for everything to work properly
" Pre-reqs:
"   - Nerd Fonts: https://www.nerdfonts.com/
"     - Installed and Configured for Terminal

" Plugins first, then settings
" Plugins ------------------------------- {{{

"""BEGIN PLUG INSTALLATION"""
set nocompatible              " required, sets vim to be incompatible with vi
filetype off                  " required, turns off automatic filetype detection for installation

" Vim Plug
source ~/.dotfiles-harrison/plug.vim

call plug#begin(expand(g:dotfiles_vim_dir.'plugged'))
    " fancy icons
    Plug 'nvim-tree/nvim-web-devicons'

    " repeat everything with '.'
    Plug 'tpope/vim-repeat'

    " better .swp file handling
    " Plug 'chrisbra/Recover.vim'

    " planery
    Plug 'nvim-lua/plenary.nvim'

    " telescope
    Plug 'kkharji/sqlite.lua'
    Plug 'prochri/telescope-all-recent.nvim'
    Plug 'nvim-telescope/telescope.nvim'

    " nvim lsp and code completion
    Plug 'williamboman/mason.nvim', { 'do': ':MasonUpdate' }
    Plug 'williamboman/mason-lspconfig.nvim'
    Plug 'neovim/nvim-lspconfig'
    Plug 'ray-x/guihua.lua', { 'do': 'cd lua/fzy && make' }
    Plug 'ray-x/navigator.lua'
    Plug 'hrsh7th/nvim-cmp'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-nvim-lua'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
    Plug 'ray-x/lsp_signature.nvim'
    Plug 'FelipeLema/cmp-async-path'

    " Github Copilot
    Plug 'zbirenbaum/copilot.lua'
    Plug 'zbirenbaum/copilot-cmp'

    " go development
    Plug 'ray-x/go.nvim', { 'for': 'go', 'do': ':GoInstallBinaries' }

    " easy alignment
    Plug 'junegunn/vim-easy-align'

    " auto-pairs
    Plug 'windwp/nvim-autopairs'

    " which-key
    Plug 'folke/which-key.nvim'

    " Text Object Plugins
    " add more builtin text object targets like quotes, tags, braces, etc...
    Plug 'wellle/targets.vim'
    " text object user denifinitions
    Plug 'kana/vim-textobj-user'
    " text object for variable segments with 'v'
    Plug 'Julian/vim-textobj-variable-segment', { 'branch': 'main' }

    " Filetype Plugins
    Plug 'sheerun/vim-polyglot'
    " tree-sitter
    Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
    Plug 'nvim-treesitter/nvim-treesitter-refactor'
    Plug 'nvim-treesitter/playground'
    " adds folding, fancy settings, and more!
    Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }

    " LaTeX Everything
    Plug 'lervag/vimtex', { 'for': 'tex' }

    " snippets for code insertion
    Plug 'L3MON4D3/LuaSnip', {'tag': 'v1.*'}

    " debug print
    Plug 'andrewferrier/debugprint.nvim'

    " auto-upcase sql terms
    Plug 'hjkatz/sql_iabbr.vim', { 'for': 'sql' }

    " comment command with 'gc'
    Plug 'tpope/vim-commentary'
    Plug 'JoosepAlviste/nvim-ts-context-commentstring'

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
    " Plug 'tommcdo/vim-fubitive'
    Plug 'tpope/vim-rhubarb'

    " act on surrounding items like quotes, tags, braces, etc...
    Plug 'tpope/vim-surround'

    " undo tree viewer and manipulater
    Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }

    " whitespace detection and deletion
    Plug 'ntpeters/vim-better-whitespace'

    " asks which file you meant to open
    Plug 'EinfachToll/DidYouMean'

    " quickfix/location list taming
    Plug 'folke/trouble.nvim'

    " git signs in the gutter
    Plug 'lewis6991/gitsigns.nvim'

    " tagbar
    Plug 'majutsushi/tagbar'

    " colorscheme tokyonight
    Plug 'folke/tokyonight.nvim'
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
" set pastetoggle=<F12>              " sets <F12> to toggle paste mode
set hlsearch                       " highlight search results
set wrap                           " wrap lines
set scrolloff=10                   " leave at least 10 lines at the bottom/top of screen when scrolling
set sidescrolloff=15               " leave at least 15 lines at the right/left of screen when scrolling
set sidescroll=1                   " scroll sidways 1 character at a time
set autowrite                      " autowrite on things like :next, :prev, :etc...
set lazyredraw                     " redraw the screen lazily
set updatetime=300                 " set vim's updatetime
set shortmess-=F                   " allow filetype-based autocommands to show popup messages
set mouse=                         " turn off mouse support
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
  if isdirectory( g:dotfiles_vim_dir . 'undo' ) == 0
    exec 'silent !mkdir -p ' . g:dotfiles_vim_dir . 'undo > /dev/null 2>&1'
  endif

  let &undodir = expand( g:dotfiles_vim_dir . 'undo' )
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

" Leader
let mapleader = ','
let maplocalleader = ","

" no longer needed in nvim with treesitter?
" turn on syntax coloring and indentation based on the filetype
" syntax on
" filetype on
" filetype indent on

" easy file reloading
nnoremap <leader>rc :w<CR>:so %<CR>

" show the syntax highlighting group of the object under the cursor
" map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
" \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
" \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" <F5> insert date
inoremap <F5> <C-R>=strftime("%c")<CR>

" keep search pattern in center of screen
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

" toggle cursorline
nnoremap <leader>cc :set cursorline!<CR>

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

" Prettify a hunk of JSON with <localleader>j
nnoremap <buffer> <localleader>j ^vg_:!python -m json.tool<cr>
vnoremap <buffer> <localleader>j :!python -m json.tool<cr>

" Move blocks of text while in visual mode
vnoremap K :m '<-2<CR>gv=gv
vnoremap J :m '>+1<CR>gv=gv
vnoremap <S-Up> :m '<-2<CR>gv=gv
vnoremap <S-Down> :m '>+1<CR>gv=gv

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

" ray-x/guihua ----------------------------- {{{

lua <<EOF

require("guihua.maps").setup({
  maps = {
      close_view = 'q',
      prev = '<Home>',
      next = '<End>',
      confirm = '<CR>',
      split = '<C-s>',
      vsplit = '<C-v>',
      tabnew = '<C-t>', -- will be hijacked to use send_qf -> trouble instead
      send_qf = '<C-q>',
  },
})

function is_win_guihua_floating(win)
  -- default to current window
  if win ~= false then win = 0 end
  -- get the config for the window
  local config = vim.api.nvim_win_get_config(win)

  -- check if the window is floating
  if config.relative == "" then return false end

  -- it just so happens that .title of each floating window created by guihua looks like this
  -- title = { { "R", "GHRainbow1" }, { "e", "GHRainbow2" }, ... }
  -- so let's check for that I guess
  if not config.title then return false end
  local title = config.title
  if #title <= 0 then return false end
  local first_item = title[1]
  if #first_item < 2 then return false end
  local first_string = first_item[2]
  if vim.startswith(first_string, "GH") then return true end

  return false
end

function hijack_guihua_mappings(buf)
  -- get bufmap for the current win
  buf = 0
  local bufmap = vim.api.nvim_buf_get_keymap(buf, 'n')

  -- find the function with lhs = "<C-Q>" (send items to quickfix)
  local fn = nil
  for _, v in pairs(bufmap) do
    if v.lhs and v.lhs == "<C-Q>" then
      fn = v.callback
      break
    end
  end

  -- -- override the new tab mapping to instead call the send to quickfix callback
  vim.keymap.set('n', '<C-t>', fn, { buffer = buf })
  vim.keymap.set('i', '<C-t>', fn, { buffer = buf })
end

vim.api.nvim_create_autocmd("WinNew", {
  pattern = "*",
  callback = function()
    if is_win_guihua_floating() then
      -- get the current buffer
      local buf = vim.api.nvim_win_get_buf(0)
      local timer = vim.loop.new_timer()
      -- delay the hijack b/c the bufmap is not filled in until after the window is created
      timer:start(50, 0, vim.schedule_wrap(hijack_guihua_mappings))
    end
  end,
})

EOF

" }}}

" nvim-autopairs ----------------------------- {{{

lua <<EOF
require("nvim-autopairs").setup({
    disable_filetype = { "TelescopePrompt" , "guihua", "guihua_rust", "clap_input" },
})

EOF

autocmd FileType guihua lua require('cmp').setup.buffer { enabled = false }
autocmd FileType guihua_rust lua require('cmp').setup.buffer { enabled = false }

" }}}

" trouble  ----------------------------- {{{

lua <<EOF
require("trouble").setup({
  -- keymaps
  keys = {
    ["?"] = "help", -- opens the trouble help
    ["q"] = "close", -- close the list
    ["<esc>"] = "cancel", -- cancel the preview and get back to your last window / buffer / cursor
    ["r"] = "refresh", -- manually refresh
    ["o"] = "jump_close", -- jump to the item and close the list
    ["<tab>"] = { -- switch severity (ERROR, WARNING, INFO, HINT, ALL)
      action = function(view)
        local f = view:get_filter("severity")
        local severity = ((f and f.filter.severity or 0) + 1) % 5
        view:filter({ severity = severity }, {
          id = "severity",
          template = "{hl:Title}Filter:{hl} {severity}",
          del = severity == 0,
        })
      end,
      desc = "Toggle Severity Filter",
    },
    ["<c-s>"] = "jump_split", -- open buffer in new split
    ["<c-v>"] = "jump_vsplit", -- open buffer in new vsplit
    ["zA"] = "fold_toggle",
    ["zR"] = "fold_toggle",
    ["<space>"] = "fold_toggle", -- toggle fold of one or all diagnostics
  },

  cycle_results = true, -- cycle item list when reaching beginning or end
  auto_open = false, -- automatically open the list when you have diagnostics
  auto_close = false, -- automatically close the list when you have no diagnostics
  auto_preview = true, -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
  auto_fold = false, -- automatically fold a file trouble list at creation
  -- auto_jump = true,
  warn_no_results = true,
  open_no_results = true,
})

local toggle_trouble = function()
  local trouble = require("trouble")

  -- Check whether we deal with a quickfix or location list buffer, close the window and open the
  -- corresponding Trouble window instead.
  if vim.fn.getloclist(0, { filewinid = 1 }).filewinid ~= 0 then
    vim.defer_fn(function()
      vim.cmd.lclose()
      trouble.toggle("loclist")
    end, 0)
  else
    vim.defer_fn(function()
      vim.cmd.cclose()
      trouble.toggle("qflist")
    end, 0)
  end
end

local trouble_next_item = function()
  require("trouble").next({
    skip_groups = true,
    jump = true,
  })
end

local trouble_prev_item = function()
  require("trouble").prev({
    skip_groups = true,
    jump = true,
  })
end

-- global mappings
vim.keymap.set('n', '<F5>', toggle_trouble)
vim.keymap.set('n', '<leader>q', toggle_trouble)
vim.keymap.set('n', '<Home>', trouble_prev_item)
vim.keymap.set('n', '<End>', trouble_next_item)

-- hijack quickfix and location lists
local function hijack_qflist()
  local trouble = require("trouble")

  -- Check whether we deal with a quickfix or location list buffer, close the window and open the
  -- corresponding Trouble window instead.
  if vim.fn.getloclist(0, { filewinid = 1 }).filewinid ~= 0 then
    vim.defer_fn(function()
      vim.cmd.lclose()
      trouble.open("loclist")
    end, 0)
  else
    vim.defer_fn(function()
      vim.cmd.cclose()
      trouble.open("qflist")
    end, 0)
  end
end

local group = vim.api.nvim_create_augroup("HijackQuickfixWithTrouble", {})
vim.api.nvim_create_autocmd("BufWinEnter", {
  pattern = "quickfix", -- buf name
  group = group,
  callback = hijack_qflist,
})

EOF

 " }}}

" telescope ----------------------------- {{{

lua <<EOF

require("telescope-all-recent").setup({
  debug = false,
  scoring = {
    recency_modifier = { -- also see telescope-frecency for these settings
      [1] = { age = 60, value = 100 }, -- past 1 hour
      [2] = { age = 240, value = 90 }, -- past 4 hours
      [3] = { age = 1440, value = 80 }, -- past day
      [4] = { age = 4320, value = 60 }, -- past 3 days
      [5] = { age = 10080, value = 40 }, -- past week
      [6] = { age = 43200, value = 20 }, -- past month
      [7] = { age = 129600, value = 10 } -- past 90 days
    },
    -- how much the score of a recent item will be improved.
    boost_factor = 0.0001
  },
  default = {
    disable = true, -- disable any unkown pickers (recommended)
    use_cwd = false, -- differentiate scoring for each picker based on cwd
    sorting = 'frecency' -- sorting: options: 'recent' and 'frecency'
  },
  pickers = { -- allows you to overwrite the default settings for each picker
    man_pages = { -- enable man_pages picker. Disable cwd and use frecency sorting.
      disable = false,
      use_cwd = false,
      sorting = 'frecency',
    },
  }
})

-- :help telescope.mappings
local telescopeMappings = {
  ["<C-e>"] = "close",
  ["<Home>"] = "move_selection_previous",
  ["<End>"] = "move_selection_next",
  ["<C-s>"] = "select_horizontal",
  ["<C-v>"] = "select_vertical",
  ["<C-k>"] = "preview_scrolling_up",
  ["<C-j>"] = "preview_scrolling_down",
  ["<C-l>"] = "preview_scrolling_right",
  ["<C-h>"] = "preview_scrolling_left",
  ["<C-t>"] = require("trouble.sources.telescope").open,
}

require("telescope").setup({
  defaults = {
    prompt_prefix = "❯ ",
    selection_caret = "❯ ",
    initial_mode = "insert", -- or "normal"
    layout_strategy = "vertical",
    mappings = {
      i = telescopeMappings,
      n = telescopeMappings,
    },
  },
})

-- cache for git rev-parse --is-inside-work-tree by pwd
local is_inside_git_tree = {}

-- returns the git root from the current directory
local get_git_root = function()
  local dot_git_path = vim.fn.finddir(".git", ".;")
  return vim.fn.fnamemodify(dot_git_path, ":h")
end

-- wraps telescope picker with opts to set cwd if inside git root, otherwise fallback to pwd
local wrap_project_files_fallback_cwd = function(fnPicker)
  return function(opts)
    if opts == nil then
        opts = {}
    end

    local cwd = vim.fn.getcwd()
    if is_inside_git_tree[cwd] == nil then
      vim.fn.system("git rev-parse --is-inside-work-tree")
      is_inside_git_tree[cwd] = vim.v.shell_error == 0
    end

    if is_inside_git_tree[cwd] then
      opts["cwd"] = get_git_root()
    end

    fnPicker(opts)
  end
end

local picker_find_files = require("telescope.builtin").find_files
local picker_live_grep = require("telescope.builtin").live_grep

-- function to open telescope with horizontal selection mapped to <CR>
local telescope_find_files_horizontal = function(opts)
  local picker = wrap_project_files_fallback_cwd(picker_find_files)

  picker({
    attach_mappings = function(_, map)
      map({"i", "n"}, "<CR>", "select_horizontal")
      return true
    end,
  })
end

-- function to open telescope with vertical selection mapped to <CR>
local telescope_find_files_vertical = function(opts)
  local picker = wrap_project_files_fallback_cwd(picker_find_files)

  picker({
    attach_mappings = function(_, map)
      map({"i", "n"}, "<CR>", "select_vertical")
      return true
    end,
  })
end

-- keymaps
vim.keymap.set('n', '<leader>ff', wrap_project_files_fallback_cwd(picker_find_files), {})
vim.keymap.set('n', '<leader>fg', wrap_project_files_fallback_cwd(picker_live_grep), {})
vim.keymap.set('n', '<leader>rg', wrap_project_files_fallback_cwd(picker_live_grep), {})
vim.keymap.set('n', '<leader>fh', require("telescope.builtin").help_tags, {}) -- :help
vim.keymap.set('n', '<leader>hh', require("telescope.builtin").help_tags, {}) -- :help
vim.keymap.set('n', 'Sp', require("telescope.builtin").help_tags, {}) -- :help

-- commands
vim.api.nvim_create_user_command( "Sp", telescope_find_files_horizontal, {})
vim.api.nvim_create_user_command( "SP", telescope_find_files_horizontal, {})
vim.api.nvim_create_user_command( "Vsp", telescope_find_files_vertical, {})
vim.api.nvim_create_user_command( "VSp", telescope_find_files_vertical, {})
vim.api.nvim_create_user_command( "VSP", telescope_find_files_vertical, {})

EOF

" }}}

" mason / mason-lspconfig --------------------------- {{{

lua <<EOF

require("mason").setup({
  -- :help mason-debugging
  -- :MasonLog
  -- log_level = vim.log.levels.DEBUG,
  install_root_dir = vim.g.dotfiles_vim_dir .. "mason",
  ui = {
      icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗"
      },
  },
})

require("mason-lspconfig").setup({
    automatic_installation = true,
    ensure_installed = {
        -- list of lsp mason packages to keep installed
        "vimls",
        "lua_ls",
        "terraformls",
        "jqls",
        -- "ltex", -- prints too many debug messages
        "taplo",
        "yamlls",
        "helm_ls",
        "pylsp",
        "jsonls",
        "gopls",
        "golangci_lint_ls", -- golangci-lint + lsp
        "dockerls",
        "bashls",
        "ts_ls",
    },
})

EOF

" }}}

" lspconfig / navigator / cmp ----------------------------- {{{

" See: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/lsp.md#you-might-not-need-lsp-zero
" See: https://github.com/ray-x/navigator.lua

lua <<EOF

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local cmp = require('cmp')
local luasnip = require('luasnip')

-- setup various cmp sources
require("copilot_cmp").setup({})

-- Enable navigator with mason support
--   - disable navigator from installing/setting up lsp (use mason and mason-lsp instead)
--   - disable navigator from configuring keymappings for lsp (use mason instead)
-- See: https://github.com/ray-x/navigator.lua/issues/239#issuecomment-1287949589
require("navigator").setup({
  debug = false,
  mason = true,
  default_mapping = false,
  lsp_signature_help = true,
  signature_help_cfg = nil, -- configure ray-x/lsp_signature_help on its own
  lines_show_prompt = 20, -- when result list is >= number, then show input prompt
  prompt_mode = 'normal', -- default mode for prompt
  lsp = {
      -- Disable all lsp setup including code actions, lens, diagnostics, etc...
      -- I will set these up via copy/paste functions from ray-x/navigator.lua
      -- into my lsp config below
      -- some config settings will still be loaded and respected during require("navigator.*").some_fn calls
      enable = false,
      disable_lsp = "all",
      code_action = {
        enable = true,
        sign = true,
        delay = 5000, -- ms
      },
      diagnostic_scrollbar_sign = false, -- disable scrollbar symbols
      diagnostic_virtual_text = '', -- empty floating text prefix
      display_diagnostic_qf = false, -- do not display qf on save
      tsserver = {
          single_file_support = true,
      },
      ts_ls = { -- renamed from tsserver
          single_file_support = true,
      },
      format_on_save = false,
  },
  icons = {
    icons = true, -- requires nerd fonts

    -- Code action
    code_action_icon = '󱐋 ',

    -- code lens
    code_lens_action_icon = '󰍉 ',

    -- Diagnostics -- appear in the sign column
    diagnostic_head = "", -- empty prefix
    diagnostic_err = "",
    diagnostic_warn = "",
    diagnostic_info = "",
    diagnostic_hint = "",

    -- these icons appear in the floating windows
    diagnostic_head_severity_1 = ' ',
    diagnostic_head_severity_2 = ' ',
    diagnostic_head_severity_3 = ' ',
    diagnostic_head_description = '', -- empty description (suffix for severities)
    diagnostic_virtual_text = '', -- empty floating text prefix
    diagnostic_file = '', -- icon in floating window indicating a file contains diagnostics

    -- Values icons appear in floating references view
    value_definition = '󰐕', -- identifier defined
    value_changed = '󰆕 ', -- identifier modified
    side_panel = {
      section_separator = '󰇜',
      line_num_left = '',
      line_num_right = '',
      inner_node = '├○',
      outer_node = '╰○',
      bracket_left = '⟪',
      bracket_right = '⟫',
    },
    -- Treesitter
    -- Note: many many more node.type or kind may be available
    match_kinds = {
      var = '󱀍 ', -- variable
      const = '󱀍 ',
      method = 'ƒ ', --  method
      ['function'] = ' ', -- function
      parameter = '󰫧 ', -- param/arg
      parameters = '󰫧 ', -- param/arg
      required_parameter = '󰫧 ', -- param/arg
      -- identifier = '󰫧 ', -- param/arg
      associated = ' ', -- linked/related
      namespace = ' ',
      type = '𝐓 ',
      field = ' ',
      module = ' ',
      flag = ' ',
      import = '󰋺 ',
    },
    treesitter_defult = ' ',
    doc_symbols = ' ',
  },
})
-- load diagnostics (disabled by lsp.enabled = false)
require('navigator.diagnostics').config({})

cmp.setup({
    -- snippet engine is _required_
    snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
    },

    window = {
        -- documentation = cmp.config.window.bordered()
    },

    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'copilot' },
        { name = 'nvim_lsp_signature_help' },
        { name = 'nvim_lua' },
        { name = 'luasnip' },
        { name = 'async_path', keyword_length = 1 },
        { name = 'buffer', keyword_length = 1 },
    }),

  -- formatting = {
  --   format = lspkind.cmp_format({
  --     mode = "symbol",
  --     max_width = 50,
  --     -- icons for cmp sources
  --     symbol_map = {
  --       Copilot = "",
  --     },
  --   })
  -- },

  preselect = cmp.PreselectMode.None,

  mapping = {
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping({
       i = function(fallback)
         if cmp.visible() and cmp.get_active_entry() then
           cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
         else
           fallback()
         end
       end,
       s = cmp.mapping.confirm({ select = true }),
       c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
     }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
    ['<Down>'] = cmp.mapping.select_next_item(),
    ['<Up>'] = cmp.mapping.select_prev_item(),
  },
})

-- link autopairs and cmp together so <cr> inserts () on Function and Method
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

local lsp_signature = require('lsp_signature').setup({
  hint_enable = true,
  hint_inline = function() return false end,
  hint_prefix = "() ",
  floating_window = false,
  floating_window_above_cur_line = true,
  handler_opts = {
      border = "rounded",
  },
  always_trigger = false,
})

local function toggle_lsp_signature()
  require('lsp_signature').toggle_float_win()
end

local lspconfig = require('lspconfig')
local lsp_defaults = lspconfig.util.default_config
local lsp_capabilities = vim.tbl_deep_extend('force', lsp_defaults.capabilities, require('cmp_nvim_lsp').default_capabilities())
local lsp_attach = function(client, bufnr)
  local opts = { buffer = bufnr }
  require("navigator.dochighlight").documentHighlight(bufnr)
  require("navigator.lspclient.highlight").add_highlight()
  require("navigator.lspclient.highlight").config_signs()
  require('navigator.lspclient.lspkind').init()
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Setup navigator for lsp client
  require("navigator.lspclient.mapping").setup({
    client = client,
    bufnr = bufnr,
  })

  -- call to show code actions as floating text and gutter icon
  local prompt_code_action = function()
    require('navigator.codeAction').code_action_prompt(bufnr)
  end

  -- ray-x/navigator
  -- ref: https://github.com/ray-x/navigator.lua/tree/master#default-keymaps
  -- ref: https://github.com/ray-x/navigator.lua/blob/master/lua/navigator/lspclient/mapping.lua
  -- must override all default mappings for any of them to work
  local keymaps = {
    { mode = 'n', key = 'gr',         func = require('navigator.reference').async_ref }, -- show references and context (async)
    { mode = 'n', key = '<c-]>',      func = require('navigator.definition').definition }, -- goto definition
    { mode = 'n', key = 'gd',         func = require('navigator.definition').definition }, -- goto definition
    { mode = 'n', key = 'gD',         func = vim.lsp.buf.declaration }, -- goto declaration
    { mode = 'n', key = '<leader>/',  func = require('navigator.workspace').workspace_symbol_live }, -- workspace fzf
    { mode = 'n', key = '<C-S-F>',    func = require('navigator.workspace').workspace_symbol_live }, -- workspace fzf
    { mode = 'n', key = 'g0',         func = require('navigator.symbols').document_symbols }, -- document's symbols
    { mode = 'n', key = '<leader>d',  func = vim.lsp.buf.hover }, -- hover window
    { mode = 'n', key = 'K',          func = vim.lsp.buf.hover }, -- hover window
    { mode = 'n', key = 'gi',         func = vim.lsp.buf.implementation }, -- goto implementation (doesn't always work?)
    { mode = 'n', key = '<Leader>gi', func = vim.lsp.buf.incoming_calls }, -- incoming calls
    { mode = 'n', key = '<Leader>go', func = vim.lsp.buf.outgoing_calls }, -- outgoing calls
    { mode = 'n', key = 'gt',         func = vim.lsp.buf.type_definition }, -- goto type definition
    { mode = 'n', key = 'gp',         func = require('navigator.definition').definition_preview }, -- hover definition preview
    { mode = 'n', key = 'gP',         func = require('navigator.definition').type_definition_preview }, -- hover type definition preview
    -- messes up ctrl-hjkl for moving windows
    -- { mode = 'n', key = '<c-k>',      func = vim.lsp.buf.signature_help }, -- sig help
    { mode = 'n', key = '<C-S-K>',    func = toggle_lsp_signature }, -- sig help
    { mode = 'i', key = '<C-S-K>',    func = toggle_lsp_signature }, -- sig help
    { mode = 'n', key = '<leader>ca', func = vim.lsp.buf.code_action }, -- code action
    { mode = 'n', key = '<leader>cl', func = require('navigator.codelens').run_action }, -- codelens action
    { mode = 'n', key = '<leader>la', func = require('navigator.codelens').run_action }, -- codelens action
    { mode = 'n', key = '<leader>rn', func = require('navigator.rename').rename }, -- rename
    { mode = 'n', key = '<leader>gt', func = require('navigator.treesitter').buf_ts }, -- fzf treesitter symbols
    { mode = 'n', key = '<leader>ts', func = require('navigator.treesitter').buf_ts }, -- fzf treesitter symbols
    { mode = 'n', key = '<leader>ct', func = require('navigator.ctags').ctags }, -- fzf ctags
    { mode = 'n', key = '<leader>ca', func = require('navigator.codeAction').code_action }, -- code action
    { mode = 'v', key = '<leader>ca', func = require('navigator.codeAction').code_action }, -- code action
    { mode = 'n', key = '<C-S-C>',    func = prompt_code_action }, -- prompt for possible code actions
    { mode = 'v', key = '<C-S-C>',    func = prompt_code_action }, -- prompt for possible code actions
    { mode = 'n', key = 'gG',         func = require('navigator.diagnostics').show_buf_diagnostics }, -- diagnostics
    { mode = 'n', key = '<leader>G',  func = require('navigator.diagnostics').show_buf_diagnostics }, -- diagnostics
    { mode = 'n', key = 'gL',         func = require('navigator.diagnostics').show_diagnostics }, -- diagnostics
    { mode = 'n', key = '<leader>L',  func = require('navigator.diagnostics').show_diagnostics }, -- diagnostics
    -- doesn't work yet in 0.10 nightly, and I don't use these anyways
    { mode = 'n', key = '<leader>cf', func = vim.lsp.buf.format }, -- format code
    { mode = 'v', key = '<leader>cf', func = require('navigator.formatting').range_format }, -- format code (visual range)
    { mode = 'n', key = '<leader>fc', func = vim.lsp.buf.format }, -- format code
    { mode = 'v', key = '<leader>fc', func = require('navigator.formatting').range_format }, -- format code (visual range)
  }

  for _, km in pairs(keymaps) do
      vim.keymap.set(km.mode, km.key, km.func, opts)
  end
end

local function dir_has_file(dir, file)
  return require("lspconfig").util.search_ancestors(dir, function(path)
    local abs_path = require("lspconfig").util.path.join(path, file)
    if require("lspconfig").util.path.is_file(abs_path) then
      return true
    end
  end)
end

-- use the lsp server name (not mason name, see the grey text name in :Mason)
-- see :Mason then <enter> on server name, then example.setting turns into example = { setting = "<value" } in the table below
local lsp_config_override = {
    yamlls = {
        settings = {
            yaml = {
                keyOrdering = false,
            },
        },
    },

    -- See: https://github.com/mrjosh/helm-ls#default-configuration
    helm_ls = {
        root_dir = function(fname)
            local root_files = {
                'Chart.yaml',
                'Chart.lock',
                'helm',
                'charts',
                '.git',
            }
            return lspconfig.util.root_pattern(unpack(root_files))(fname) or lspconfig.util.path.dirname(fname)
        end,
        settings = {
            ['helm-ls'] = {
                yamlls = {
                    enabled = false, -- not yet working, see: https://github.com/mrjosh/helm-ls/issues/44
                    enabledForFilesGlob = "*.{yaml.yml}",
                    path = "yaml-language-server",
                    config = {
                        keyOrdering = false,
                    },
                },
            },
        },
    },

    -- See: https://github.com/golang/tools/blob/master/gopls/doc/settings.md
    -- See: https://ngrok.slack.com/archives/C0405411BG9/p1698257254042009?thread_ts=1698180961.267949&cid=C0405411BG9
    -- See: https://github.com/neovim/neovim/issues/23291#issuecomment-1560742827
    -- See: https://github.com/golang/go/issues/41504
    gopls = {
        root_dir = function(fname)
            local root_files = {
                'go.mod',
                'go/go.mod', -- ngrok
                'go.work',
                '.git',
            }
            return lspconfig.util.root_pattern(unpack(root_files))(fname) or lspconfig.util.path.dirname(fname)
        end,
    },

    -- See: https://github.com/nametake/golangci-lint-langserver
    golangci_lint_ls = {
    },

    terraformls = {
        root_dir = function(fname)
            local root_files = {
                '.terraform_root', -- ngrok
                '.terraform',
                '.git',
            }
            return lspconfig.util.root_pattern(unpack(root_files))(fname) or lspconfig.util.path.dirname(fname)
        end,
    },

    -- See: https://github.com/python-lsp/python-lsp-server/blob/develop/CONFIGURATION.md
    pylsp = {
        settings = {
            pylsp = {
                plugins = {
                    pycodestyle = {
                        enabled = true,
                        ignore = {
                            'E402', -- module level import not at top of file
                            'E501', -- line too long
                            'E731', -- do not assign a lambda expression, use a def
                            'W503', -- line break before binary operator
                            'W504', -- line break after binary operator
                        },
                    },
                },
            },
        },
    },

    -- See: https://github.com/microsoft/pyright
    pyright = {
      on_new_config = function(new_config, dir)
        if dir_has_file(dir, "poetry.lock") then
          -- vim.notify_once("Running `pyright` with `poetry`")
          new_config.cmd = { "poetry", "run", "pyright-langserver", "--stdio" }
        elseif dir_has_file(dir, "Pipfile") then
          -- vim.notify_once("Running `pyright` with `pipenv`")
          new_config.cmd = { "pipenv", "run", "pyright-langserver", "--stdio" }
        else
          -- vim.notify_once("Running `pyright` without a virtualenv")
        end
      end,
    },
}

-- disable watch files until this is fixed
-- see: https://github.com/neovim/neovim/issues/23291
-- require('vim.lsp._watchfiles')._watchfunc = function(_, _, _) return true end

-- set default value for lsp_config_override that are not configured from defaults
setmetatable(lsp_config_override, { __index=function() return {} end })

local get_lspconfig = function(server_name)
  local opts = {
    on_attach    = lsp_attach,
    capabilities = lsp_capabilities,
  }

  -- if lsp_config_override exists for server_name
  if lsp_config_override[server_name] ~= false then
      -- then merge the settings into the opts
      opts = vim.tbl_extend('force', opts, lsp_config_override[server_name])
  end

  return opts
end

-- all handlers should use the default on_attach and capabilities
-- see lsp_settings above for per-lsp settings
local mason_handlers = {
    -- The first entry (without a key) will be the default handler
    -- and will be called for each installed server that doesn't have
    -- a dedicated handler.
    function (server_name)
        lspconfig[server_name].setup(get_lspconfig(server_name))
    end,
}

require('mason-lspconfig').setup_handlers(mason_handlers)

EOF

" Mappings for jump to definition
nmap <C-n> gd
nmap <C-t> <C-o>

" }}}

" treesitter ----------------------------- {{{

lua <<END

require'nvim-treesitter.configs'.setup {
  ensure_installed = {
    "c",
    "cmake",
    "comment",
    "diff",
    "dockerfile",
    "git_config",
    "git_rebase",
    "gitcommit",
    "gitignore",
    "go",
    "gomod",
    "gosum",
    "gowork",
    "hcl",
    "html",
    "ini",
    "javascript",
    "jq",
    "json",
    "json5",
    "jsonnet",
    "lua",
    "luadoc",
    "make",
    -- "markdown", see: https://github.com/nvim-treesitter/nvim-treesitter/issues/2916
    "nix",
    "proto",
    "python",
    "regex",
    "rust",
    "sql",
    "terraform",
    "toml",
    "typescript",
    "vim",
    "vimdoc",
    "yaml",
    "query",
  },

  sync_install = false,
  auto_install = true,

  highlight = {
    enable = true,
  },

  indent = {
      enable = true,
  },

  playground = {
      enable = true,
  }
}

require('ts_context_commentstring').setup {
  enable = true,

  languages = {
    terraform = '# %s',
  },
}

-- skip backwards compatability check to speed up loading
vim.g.skip_ts_context_commentstring_module = true

END

" }}}

" golden ratio ----------------------------- {{{

" don't resize nonmodifiable windows like quickfix/location/tag lists
" let g:golden_ratio_exclude_nonmodifiable = 1

" }}}

" vimtex ----------------------------- {{{

let g:vimtex_view_method = 'zathura'

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

" vim-fubitive ----------------------------- {{{

" configure bitbucket for code.squarespace.net
let g:fubitive_domain_pattern = 'code\.squarespace\.net'

" }}}

" tagbar ----------------------------- {{{

nnoremap <silent> <F2> :TagbarToggle<CR>

let g:tagbar_map_togglefold = '<Space>'
let g:tagbar_autofocus = 1

" }}}

" which-key ----------------------------- {{{

lua <<EOF

require("which-key").setup({
  plugins = {
    marks = false,
    registers = false,
    spelling = {
      enabled = true,
      suggestions = 20,
    },
    presets = {
      operators = false,
      motions = false,
      text_objects = false,
      windows = false,
      nav = false,
      z = false,
      g = false,
    },
  },
})

EOF

" }}}

" debugprint ----------------------------- {{{

lua <<EOF

require("debugprint").setup({
  -- keymaps = false,
  move_to_debugline = true,
  display_snippet = true,
  display_counter = true,
  print_tag = "DEBUGPRINT",
})

vim.keymap.set("n", "<leader>dD", function()
  return require("debugprint").debugprint({ above = true })
end, { expr = true })

vim.keymap.set("n", "<leader>dd", function()
  return require("debugprint").debugprint({})
end, { expr = true })

vim.keymap.set("n", "<leader>dV", function()
  return require("debugprint").debugprint({ above = true, variable = true })
end, { expr = true })

vim.keymap.set("n", "<leader>dv", function()
  return require("debugprint").debugprint({ variable = true })
end, { expr = true })

EOF

" }}}

" gitsigns ----------------------------- {{{

lua <<EOF

require("gitsigns").setup({
  signcolumn = true, -- show gitsigns in the sign column
  numhl = true, -- highlight the line number column too
  current_line_blame = true,
  current_line_blame_formatter = '[<author_mail>, <author_time:%Y-%m-%d> [<abbrev_sha>] - <summary>]',
  current_line_blame_formatter_nc = '[Not committed yet]',
  trouble = true,
})

vim.keymap.set('n', '<leader>gb', require('gitsigns').blame_line, {})
vim.keymap.set('n', '<leader>bl', require('gitsigns').blame_line, {})

EOF

" }}}

" copilot --------------------------- {{{

lua <<EOF

-- configure copilot.lua
require("copilot").setup({
  suggestion = {
    enabled = true,
    auto_trigger = true,
    keymap = {
      accept = "<C-t>",
    },
  },

  filetypes = {
    yaml = true,
    markdown = true,
  }
})

EOF

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
" see: https://vi.stackexchange.com/a/22460
aug NoInsertFolding
    au!
    au InsertEnter * let w:oldfdm = &l:foldmethod | setlocal foldmethod=manual
    au InsertLeave *
          \ if exists('w:oldfdm') |
          \   let &l:foldmethod = w:oldfdm |
          \   unlet w:oldfdm |
          \ endif |
          \ normal! zv
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
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set foldenable
set foldlevelstart=0

" Space to toggle folds.
nnoremap <Space> za
vnoremap <Space> za
" Shift+Space to toggle folds recursively.
nnoremap <Enter> zA
vnoremap <Enter> zA

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

" Go {{{

augroup ft_go
   au!

    lua <<EOF

    -- auto formattingon save
    local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*.go",
      callback = function()
       require('go.format').goimport()
      end,
      group = format_sync_grp,
    })

    require('go').setup({
        luasnip = true,
        lsp_cfg = false, -- use my own lspconfig
        trouble = true,
    })

EOF

   " Recursive toggle
   au FileType go nnoremap <buffer> <Space> zA
   au FileType go vnoremap <buffer> <Space> zA

   " Alternate between test files (use A! to create file)
   au Filetype go command! -bang A GoAlt
   au Filetype go command! -bang AV GoAltV
   au Filetype go command! -bang AS GoAltS

   " " run :GoBuild or :GoTestCompile based on the go file
   " function! s:build_go_files()
   "   let l:file = expand('%')
   "   if l:file =~# '^\f\+_test\.go$'
   "     call go#test#Test(0, 1)
   "   elseif l:file =~# '^\f\+\.go$'
   "     call go#cmd#Build(0)
   "   endif
   " endfunction

   " " set the vim-go guru scope from the git root
   " function! s:go_guru_scope_from_git_root()
   " " chomp because get rev-parse returns line with newline at the end
   "   return s:chomp(s:substring(system("git rev-parse --show-toplevel"),$GOPATH . "/src/","")) . "/..."
   " endfunction

   " " do this everytime we open a go file
   " " au FileType go silent exe "GoGuruScope " . s:go_guru_scope_from_git_root()

   " " setup some leaders
   " Go build current package of current file
   au FileType go nmap <buffer> <leader>b :GoBuild %:h<CR>
   au FileType go nmap <buffer> <Leader>t :GoTestFile<CR>
   au FileType go nmap <buffer> <Leader>tf :GoTestFunc<CR>

   " abbreviations
   au FileType go iabbrev <buffer> === :=
   au FileType go iabbrev <buffer> !! !=
   au FileType go iabbrev <buffer> importlogrus log "github.com/sirupsen/logrus"
   au FileType go iabbrev <buffer> importlog log "github.com/sirupsen/logrus"
   au FileType go iabbrev <buffer> importspew "github.com/davecgh/go-spew/spew"
   au FileType go iabbrev <buffer> importassert "github.com/stretchr/testify/assert"
   au FileType go iabbrev <buffer> importmetav1 metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
augroup END

" }}}
" Helm (yaml) {{{

augroup ft_helm
    au!

    " use # for comments instead of default /* ... */
    au FileType helm setlocal commentstring=#\ %s
augroup END

" }}}
" Javascript {{{

augroup ft_javascript
    au!

    " Recursive toggle
    au FileType javascript nnoremap <buffer> <Space> zA
    au FileType javascript vnoremap <buffer> <Space> zA

augroup END

" }}}
" Typescript {{{

augroup ft_typescript
    au!

    " Recursive toggle
    au FileType typescript nnoremap <buffer> <Space> zA
    au FileType typescript vnoremap <buffer> <Space> zA

    au FileType typescript setlocal ts=2
    au FileType typescript setlocal sw=2
    au FileType typescript setlocal expandtab

augroup END

" }}}
" JSON {{{

augroup ft_json
    au!

    " Recursive toggle
    au FileType json nnoremap <buffer> <Space> zA
    au FileType json vnoremap <buffer> <Space> zA
augroup END

" }}}
" jsonnet {{{

augroup ft_jsonnet
    au!

    au FileType jsonnet setlocal ts=2
    au FileType jsonnet setlocal sw=2
    au FileType jsonnet setlocal expandtab

    " Recursive toggle
    au FileType jsonnet nnoremap <buffer> <Space> zA
    au FileType jsonnet vnoremap <buffer> <Space> zA

    " use # for comments instead of default //
    au FileType jsonnet setlocal commentstring=#\ %s
augroup END

" }}}
" Latex {{{

augroup ft_latex
    au!

    " Recursive toggle
    au FileType latex nnoremap <buffer> <Space> zA
    au FileType latex vnoremap <buffer> <Space> zA

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
" Python {{{

augroup ft_python
    au!

    au FileType python setlocal define=^\s*\\(def\\\\|class\\)

    " Recursive toggle
    au FileType python nnoremap <buffer> <Space> zA
    au FileType python vnoremap <buffer> <Space> zA
augroup END

" }}}
" Vim {{{

augroup ft_vim
    au!

    au FileType vim setlocal foldmethod=marker
    au FileType help setlocal textwidth=80
augroup END

" }}}

" }}}
" Colorscheme {{{

set background=dark
highlight clear

if exists( "syntax_on" )
  syntax reset
endif

lua <<EOF

require("tokyonight").setup({
  style = "night", -- extra dark
  transparent = true,
  terminal_colors = true,
  styles = {
    -- Style to be applied to different syntax groups
    -- Value is any valid attr-list value for `:help nvim_set_hl`
    comments = { italic = true },
    keywords = { italic = true },
    functions = {},
    variables = {},
    -- Background styles. Can be "dark", "transparent" or "normal"
    sidebars = "dark", -- style for sidebars, see below
    floats = "dark", -- style for floating windows
  },
})

EOF

colorscheme tokyonight-night

" }}}
