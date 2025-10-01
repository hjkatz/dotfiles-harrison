---@diagnostic disable: undefined-global
-- Author: Harrison Katz <hjkatz03@gmail.com>
--
-- This is my personal init.lua for Neovim, converted from vimrc
-- Feel free to ask me questions about anything that you may not understand. Thanks for taking a look!

-- Set dotfiles directory
vim.g.dotfiles_vim_dir = vim.env.HOME .. '/.dotfiles-harrison/.vim/'

-- Note: These must be installed on the system for everything to work properly
-- Pre-reqs:
--   - Nerd Fonts: https://www.nerdfonts.com/
--     - Installed and Configured for Terminal

-- Plugins first, then settings
-- ============================================================================
-- Plugin Installation
-- ============================================================================

-- lua config
table.unpack = table.unpack or unpack  -- for compatibility with older versions of Lua

-- Load vim-plug for plugin management
vim.cmd('source ~/.dotfiles-harrison/plug.vim')

-- Initialize plugins with vim-plug
vim.cmd([[
call plug#begin(expand(g:dotfiles_vim_dir.'plugged'))
    " fancy icons
    Plug 'nvim-tree/nvim-web-devicons'

    " repeat everything with '.'
    Plug 'tpope/vim-repeat'

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
    " Plug 'nvim-java/nvim-java'
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
]])

-- Enable filetype plugin and indent
vim.cmd('filetype plugin indent on')

-- ============================================================================
-- General Settings
-- ============================================================================

local opt = vim.opt

-- Basic settings
opt.tabstop = 4                 -- tab spacing is 4 spaces
opt.shiftwidth = 4              -- shift width is 4 spaces
opt.expandtab = true            -- expand all tabs to spaces
opt.autoindent = true           -- autoindent a file based on filetype
opt.cindent = true              -- c-style indenting while typing
opt.background = 'dark'         -- our backdrop is dark
opt.number = true               -- show line numbers
opt.ruler = true                -- show row,col count on bottom bar
opt.backspace = {'eol', 'start', 'indent'}  -- backspace wraps around indents, start of lines, and end of lines
opt.ignorecase = true           -- ignore case when searching
opt.smartcase = true            -- ...unless we have atleast 1 capital letter
opt.incsearch = true            -- search incrementally
opt.infercase = true            -- infer the case of the completion word
opt.formatoptions = 'tcqronj'   -- see :help fo-table for more information
opt.hlsearch = true             -- highlight search results
opt.wrap = true                 -- wrap lines
opt.scrolloff = 10              -- leave at least 10 lines at the bottom/top of screen when scrolling
opt.sidescrolloff = 15          -- leave at least 15 lines at the right/left of screen when scrolling
opt.sidescroll = 1              -- scroll sidways 1 character at a time
opt.autowrite = true            -- autowrite on things like :next, :prev, :etc...
opt.lazyredraw = true           -- redraw the screen lazily
opt.updatetime = 300            -- set vim's updatetime
opt.shortmess:remove('F')       -- allow filetype-based autocommands to show popup messages
opt.mouse = ''                  -- turn off mouse support

-- Wildmenu completion
opt.wildmenu = true
opt.wildmode = {'longest:full', 'full'}
opt.wildignore:append({
    '.hg,.git,.svn',                    -- Version control
    '*.aux,*.out,*.toc',                -- LaTeX intermediate files
    '*.jpg,*.bmp,*.gif,*.png,*.jpeg',   -- binary images
    '*.o,*.obj,*.exe,*.dll,*.manifest', -- compiled object files
    '*.spl',                            -- compiled spelling word lists
    '*.sw?',                            -- Vim swap files
    '*.luac',                           -- Lua byte code
    '*.pyc',                            -- Python byte code
    '*.orig'                            -- Merge resolution files
})

-- Persistent undo
if vim.fn.has('persistent_undo') == 1 then
    local undo_dir = vim.g.dotfiles_vim_dir .. 'undo'
    if vim.fn.isdirectory(undo_dir) == 0 then
        vim.fn.system('mkdir -p ' .. undo_dir)
    end
    opt.undodir = undo_dir
    opt.undofile = true
end

-- Auto save and read
opt.autoread = true

-- ============================================================================
-- Functions
-- ============================================================================

-- Pulse Line function
local function pulse()
    local old_hi = vim.api.nvim_exec('hi CursorLine', true)
    local steps = 8
    local width = 1
    local start = width
    local end_val = steps * width
    local color = 233

    for i = start, end_val, width do
        vim.cmd('hi CursorLine ctermbg=' .. (color + i))
        vim.cmd('redraw')
        vim.cmd('sleep 6m')
    end

    for i = end_val, start, -width do
        vim.cmd('hi CursorLine ctermbg=' .. (color + i))
        vim.cmd('redraw')
        vim.cmd('sleep 6m')
    end

    vim.cmd('hi ' .. old_hi)
end

-- Create command for pulse
vim.api.nvim_create_user_command('Pulse', pulse, {})

-- ============================================================================
-- Key Mappings
-- ============================================================================

-- Leader keys
vim.g.mapleader = ','
vim.g.maplocalleader = ','

local keymap = vim.keymap.set

-- Easy file reloading
keymap('n', '<leader>rc', ':w<CR>:so %<CR>')

-- Insert date
keymap('i', '<F5>', function() return vim.fn.strftime('%c') end, { expr = true })

-- Keep search pattern in center of screen
keymap('n', 'n', 'nzz')
keymap('n', 'N', 'Nzz')
keymap('n', '*', '*zz')
keymap('n', '#', '#zz')
keymap('n', 'g*', 'g*zz')
keymap('n', 'g#', 'g#zz')

-- Toggle cursorline
keymap('n', '<leader>cc', ':set cursorline!<CR>')

-- Don't move cursor on '*'
keymap('n', '*', function()
    local view = vim.fn.winsaveview()
    vim.cmd('normal! *')
    vim.fn.winrestview(view)
end, { silent = true })

-- Move in split windows with ctrl+hjkl
keymap('n', '<C-h>', '<C-w>h')
keymap('n', '<C-j>', '<C-w>j')
keymap('n', '<C-k>', '<C-w>k')
keymap('n', '<C-l>', '<C-w>l')

-- Move up/down on wrapped lines
keymap('n', 'j', 'gj')
keymap('n', 'k', 'gk')

-- Prevent accidental help
keymap({'n', 'i'}, '<F1>', '<Esc>')

-- More intuitive increment/decrement with +/-
keymap('n', '+', '<C-a>')
keymap('n', '-', '<C-x>')

-- Panic Button
keymap('n', '<F9>', 'mzggg?G`z')

-- Use sane regexes
keymap({'n', 'v'}, '/', '/\\v')

-- Move blocks of text while in visual mode
keymap('v', 'K', ":m '<-2<CR>gv=gv")
keymap('v', 'J', ":m '>+1<CR>gv=gv")
keymap('v', '<S-Up>', ":m '<-2<CR>gv=gv")
keymap('v', '<S-Down>', ":m '>+1<CR>gv=gv")

-- Ctrl-Y by word
keymap('i', '<C-y>', function()
    local line = vim.fn.getline(vim.fn.line('.') - 1)
    local col = vim.fn.virtcol('.')
    return vim.fn.matchstr(line, string.format('\\%%%dv\\%%(%%(\\k\\+\\)\\|.\\)', col))
end, { expr = true })

-- Disable Ex mode and command history
keymap('n', 'Q', '<Nop>')
keymap('n', 'q:', '<Nop>')

-- Jump to definition mappings
keymap('n', '<C-N>', function()
    -- Use LSP definition if available, otherwise fallback to gd
    if vim.lsp.get_active_clients({bufnr = 0})[1] then
        vim.lsp.buf.definition()
    else
        local keys = vim.api.nvim_replace_termcodes('gd', true, false, true)
        vim.api.nvim_feedkeys(keys, 'n', false)
    end
end, { noremap = true, silent = true })
keymap('n', '<C-t>', '<C-o>')

-- ============================================================================
-- Commands
-- ============================================================================

-- Remap stupid shift letters
vim.api.nvim_create_user_command('Q', 'q', {})
vim.api.nvim_create_user_command('W', 'w', {})
vim.api.nvim_create_user_command('Wq', 'wq', {})

-- Allow saving of files as sudo when I forgot to start vim using sudo
vim.keymap.set('c', 'w!!', 'w !sudo tee > /dev/null %')
vim.keymap.set('c', 'w;', 'wq')
vim.keymap.set('c', ';', 'q')
vim.keymap.set('c', '::', ';')

-- Prettify JSON
keymap({'n', 'v'}, '<localleader>j', function()
    if vim.fn.mode() == 'v' then
        vim.cmd("'<,'>!python -m json.tool")
    else
        vim.cmd('^vg_:!python -m json.tool<cr>')
    end
end)

-- ============================================================================
-- Plugin Configuration
-- ============================================================================

require("guihua.maps").setup({
    maps = {
        close_view = 'q',
        prev = '<Home>',
        next = '<End>',
        confirm = '<CR>',
        split = '<C-s>',
        vsplit = '<C-v>',
        tabnew = '<C-t>',
        send_qf = '<C-q>',
    },
})

-- Function to check if window is guihua floating
local function is_win_guihua_floating(win)
    if win ~= false then win = 0 end
    local config = vim.api.nvim_win_get_config(win)

    if config.relative == "" then return false end

    if not config.title then return false end
    local title = config.title
    if #title <= 0 then return false end
    local first_item = title[1]
    if #first_item < 2 then return false end
    local first_string = first_item[2]
    if vim.startswith(first_string, "GH") then return true end

    return false
end

-- Function to hijack guihua mappings
local function hijack_guihua_mappings(buf)
    buf = 0
    local bufmap = vim.api.nvim_buf_get_keymap(buf, 'n')

    local fn = nil
    for _, v in pairs(bufmap) do
        if v.lhs and v.lhs == "<C-Q>" then
            fn = v.callback
            break
        end
    end

    vim.keymap.set('n', '<C-t>', fn, { buffer = buf })
    vim.keymap.set('i', '<C-t>', fn, { buffer = buf })
end

-- Auto command for guihua window hijacking
vim.api.nvim_create_autocmd("WinNew", {
    pattern = "*",
    callback = function()
        if is_win_guihua_floating() then
            local timer = vim.loop.new_timer()
            timer:start(50, 0, vim.schedule_wrap(hijack_guihua_mappings))
        end
    end,
})

-- nvim-autopairs
require("nvim-autopairs").setup({
    disable_filetype = { "TelescopePrompt", "guihua", "guihua_rust", "clap_input" },
})

-- Disable cmp for guihua filetypes
vim.api.nvim_create_autocmd("FileType", {
    pattern = {"guihua", "guihua_rust"},
    callback = function()
        require('cmp').setup.buffer { enabled = false }
    end
})

-- trouble setup
require("trouble").setup({
    mode = "quickfix",
    keys = {
        ["?"] = "help",
        ["q"] = "close",
        ["<esc>"] = "cancel",
        ["r"] = "refresh",
        ["o"] = "jump_close",
        ["<tab>"] = {
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
        ["<c-s>"] = "jump_split",
        ["<c-v>"] = "jump_vsplit",
        ["zA"] = "fold_toggle",
        ["zR"] = "fold_toggle",
        ["<space>"] = "fold_toggle",
    },
    cycle_results = true,
    auto_open = false,
    auto_close = false,
    auto_preview = true,
    auto_fold = false,
    warn_no_results = true,
    open_no_results = true,
})

-- Trouble key mappings and functions
local function toggle_trouble()
    require('trouble').toggle("qflist")

    -- if vim.fn.getloclist(0, { filewinid = 1 }).filewinid ~= 0 then
    --     vim.defer_fn(function()
    --         vim.cmd.lclose()
    --         trouble.toggle("loclist")
    --     end, 0)
    -- else
    --     vim.defer_fn(function()
    --         vim.cmd.lclose()
    --         trouble.toggle("loclist")
    --     end, 0)
    -- end
end

-- local function trouble_next_item()
--     local trouble = require('trouble')
--     local current_idx = vim.fn.getqflist({idx = 0}).idx
--     local items = trouble.get_items()

--     -- If we're at the last item, cycle to first
--     if current_idx >= #items then
--         trouble.first({
--             skip_groups = true,
--             jump = true,
--         })
--     else
--         trouble.next({
--             skip_groups = true,
--             jump = true,
--         })
--     end
-- end

-- local function trouble_prev_item()
--     local trouble = require('trouble')
--     -- local current_idx = vim.fn.getqflist({idx = 0}).idx

--     -- Get the current view to check position
--     local view = trouble._find_last()
--     if not view then return end

--     local items = view.items or {}
--     if #items == 0 then return end

--     -- Get current position
--     local current_idx = view.pos or 1

--     -- If we're at the first item, cycle to last
--     if current_idx <= 1 then
--         trouble.last({
--             skip_groups = true,
--             jump = true,
--         })
--     else
--         trouble.prev({
--             skip_groups = true,
--             jump = true,
--         })
--     end
-- end

local function trouble_next_item()
    require('trouble').next({
        skip_groups = true,
        jump = true,
    })

end

local function trouble_prev_item()
    require('trouble').prev({
        skip_groups = true,
        jump = true,
    })
end

-- Global trouble mappings
keymap('n', '<F5>', toggle_trouble)
keymap('n', '<leader>q', toggle_trouble)
keymap('n', '<Home>', trouble_prev_item)
keymap('n', '<End>', trouble_next_item)

-- Hijack quickfix and location lists
local function hijack_trouble_loclist()
    if vim.fn.getloclist(0, { filewinid = 1 }).filewinid ~= 0 then
        vim.defer_fn(function()
            vim.cmd.lclose()
            require('trouble').open("qflist")
        end, 0)
    -- else
    --     vim.defer_fn(function()
    --         vim.cmd.lclose()
    --         trouble.open("loclist")
    --     end, 0)
    end
end

local group = vim.api.nvim_create_augroup("HijackQuickfixWithTrouble", {})
vim.api.nvim_create_autocmd("BufWinEnter", {
    pattern = "quickfix",
    group = group,
    callback = hijack_trouble_loclist,
})

-- telescope-all-recent setup
require("telescope-all-recent").setup({
    debug = false,
    scoring = {
        recency_modifier = {
            [1] = { age = 60, value = 100 },
            [2] = { age = 240, value = 90 },
            [3] = { age = 1440, value = 80 },
            [4] = { age = 4320, value = 60 },
            [5] = { age = 10080, value = 40 },
            [6] = { age = 43200, value = 20 },
            [7] = { age = 129600, value = 10 }
        },
        boost_factor = 0.0001
    },
    default = {
        disable = true,
        use_cwd = false,
        sorting = 'frecency'
    },
    pickers = {
        man_pages = {
            disable = false,
            use_cwd = false,
            sorting = 'frecency',
        },
    }
})

-- Telescope setup
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
        initial_mode = "insert",
        layout_strategy = "vertical",
        mappings = {
            i = telescopeMappings,
            n = telescopeMappings,
        },
    },
})

-- Git root utility functions
local is_inside_git_tree = {}

local function get_git_root()
    local dot_git_path = vim.fn.finddir(".git", ".;")
    return vim.fn.fnamemodify(dot_git_path, ":h")
end

local function wrap_project_files_fallback_cwd(fnPicker)
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

-- Telescope file pickers with different selection modes
local function telescope_find_files_horizontal()
    local picker = wrap_project_files_fallback_cwd(picker_find_files)

    picker({
        attach_mappings = function(_, map)
            map({"i", "n"}, "<CR>", "select_horizontal")
            return true
        end,
    })
end

local function telescope_find_files_vertical()
    local picker = wrap_project_files_fallback_cwd(picker_find_files)

    picker({
        attach_mappings = function(_, map)
            map({"i", "n"}, "<CR>", "select_vertical")
            return true
        end,
    })
end

-- Telescope keymaps
keymap('n', '<leader>ff', wrap_project_files_fallback_cwd(picker_find_files))
keymap('n', '<leader>fg', wrap_project_files_fallback_cwd(picker_live_grep))
keymap('n', '<leader>rg', wrap_project_files_fallback_cwd(picker_live_grep))
keymap('n', '<leader>fh', require("telescope.builtin").help_tags)
keymap('n', '<leader>hh', require("telescope.builtin").help_tags)
keymap('n', 'Sp', require("telescope.builtin").help_tags)

-- Telescope commands
vim.api.nvim_create_user_command("Sp", telescope_find_files_horizontal, {})
vim.api.nvim_create_user_command("SP", telescope_find_files_horizontal, {})
vim.api.nvim_create_user_command("Vsp", telescope_find_files_vertical, {})
vim.api.nvim_create_user_command("VSp", telescope_find_files_vertical, {})
vim.api.nvim_create_user_command("VSP", telescope_find_files_vertical, {})

-- Mason setup
local mason_install_path = vim.g.dotfiles_vim_dir .. "mason"
require("mason").setup({
    install_root_dir = mason_install_path,
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        },
    },
})

-- Workaround for missing vim.lsp.enable in some Neovim versions
if not vim.lsp.enable then
    vim.lsp.enable = function()
        -- No-op function to prevent errors
        return true
    end
end

-- require('java').setup()

require("mason-lspconfig").setup({
    automatic_enable = false,  -- Disable automatic enable feature to avoid vim.lsp.enable error
    ensure_installed = {
        "vimls",
        "lua_ls",
        "terraformls",
        "jqls",
        "taplo",
        "yamlls",
        "helm_ls",
        "pylsp",
        "jsonls",
        "gopls",
        "golangci_lint_ls",
        "dockerls",
        "bashls",
        "ts_ls",
    },
})

local function mason_package_path(package)
  local path = vim.fn.resolve(mason_install_path .. "/packages/" .. package)
  return path
end

-- using vim.fn.expand inside the callback gives the following error:
--   vimL function must not be called in a lua loop callback
local pylsp_path = mason_package_path("python-lsp-server")
local pylsp = require("mason-registry").get_package("python-lsp-server")
local pip_path = vim.fn.expand(pylsp_path .. "/venv/bin/pip")

-- install pylsp-mypy
local function install_pylsp_mypy()
    if not pylsp:is_installed() then
        vim.notify("python-lsp-server is not installed", vim.log.levels.WARN, { title = "mason.nvim" })
        return
    end

    vim.fn.system({ pip_path, "install", "pylsp-mypy" })
    vim.notify("pylsp-mypy installed", vim.log.levels.INFO, { title = "mason.nvim" })
end

pylsp:on("install:success", function()
    vim.schedule_wrap(install_pylsp_mypy)()
end)

-- LSP and completion setup
local function has_words_before()
    local line, col = table.unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local cmp = require('cmp')
local luasnip = require('luasnip')

-- Setup copilot cmp - disabled due to serialization errors
require("copilot_cmp").setup({})

-- Navigator setup - disabled due to persistent CursorHold errors
require("navigator").setup({
    debug = false,
    mason = false,  -- Disable mason integration
    default_mapping = false,
    lsp_signature_help = false,  -- Disable signature help
    signature_help_cfg = nil,
    lines_show_prompt = 20,
    prompt_mode = 'normal',
    keymaps = {},  -- Disable default keymaps
    lsp = {
	    enable = false,
        disable_lsp = "all",
        code_action = {
            enable = false,
            sign = false,
            delay = 0,  -- Set to 0 to disable
        },
        code_lens = false,  -- Disable code lens
        diagnostic_scrollbar_sign = false,
        diagnostic_virtual_text = '',
        display_diagnostic_qf = false,
        diagnostic = {
            enable = false, -- somehow this actually _enables_ diagnostics to work
            float = false,
            -- float = {
            --     border = 'rounded',
            -- },
            virtual_lines = {
                current_line = false,
            }
        },
        tsserver = {
            single_file_support = true,
        },
        ts_ls = {
            single_file_support = true,
        },
        format_on_save = false,
    },
    icons = {
        icons = true,
        code_action_icon = '󱐋 ',
        code_lens_action_icon = '󰍉 ',
        diagnostic_head = "",
        diagnostic_err = "",
        diagnostic_warn = "",
        diagnostic_info = "",
        diagnostic_hint = "",
        diagnostic_head_severity_1 = ' ',
        diagnostic_head_severity_2 = ' ',
        diagnostic_head_severity_3 = ' ',
        diagnostic_head_description = '',
        diagnostic_virtual_text = '',
        diagnostic_file = '',
        value_definition = '󰐕',
        value_changed = '󰆕 ',
        side_panel = {
            section_separator = '󰇜',
            line_num_left = '',
            line_num_right = '',
            inner_node = '├○',
            outer_node = '╰○',
            bracket_left = '⟪',
            bracket_right = '⟫',
        },
        match_kinds = {
            var = '󱀍 ',
            const = '󱀍 ',
            method = 'ƒ ',
            parameter = '󰫧 ',
            parameters = '󰫧 ',
            required_parameter = '󰫧 ',
            associated = ' ',
            namespace = ' ',
            type = '𝐓 ',
            field = ' ',
            module = ' ',
            flag = ' ',
            import = '󰋺 ',
        },
        treesitter_defult = ' ',
        doc_symbols = ' ',
    },
})

-- CMP setup
cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },

    experimental = {
        ghost_text = true,
    },

    sources = cmp.config.sources({
        { name = 'copilot', priority = 100 },
        { name = 'nvim_lsp', priority = 90 },
        { name = 'luasnip', priority = 80 },
        { name = 'nvim_lsp_signature_help', priority = 70 },
        { name = 'nvim_lua', priority = 60 },
        { name = 'async_path', keyword_length = 1, priority = 50 },
        { name = 'buffer', keyword_length = 3, priority = 10 },
    }),

    sorting = {
        priority_weight = 2,
        comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            cmp.config.compare.locality,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
        },
    },

    preselect = cmp.PreselectMode.None,

    mapping = {
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<C-n>'] = cmp.mapping(function(fallback)
            fallback() -- Always fallback, don't handle C-n in CMP
        end, { "i", "s" }),
        ['<C-t>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
            else
                fallback()
            end
        end, { "i", "s" }),
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
                fallback()
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

-- Link autopairs and cmp
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

local lsp_capabilities = vim.tbl_deep_extend('force',
    require('lspconfig').util.default_config.capabilities,
    require('cmp_nvim_lsp').default_capabilities())

local function toggle_diagnostics()
  local trouble = require("trouble")
  if trouble.is_open() then
        trouble.close()
    else
        vim.diagnostic.setqflist()
  end
end

local function lsp_hover()
    return vim.lsp.buf.hover({
      border = "rounded",
    })
end

local function qflist_references()
	local win = vim.api.nvim_get_current_win()
	vim.lsp.buf.references(nil, {
		on_list = function(items, title, context)
			vim.fn.setqflist({}, " ", items)
            require('trouble').open("qflist")
			-- vim.cmd.copen()
			vim.api.nvim_set_current_win(win)
		end,
	})
end

local function lsp_attach(client, bufnr)
    local opts = { buffer = bufnr }
    -- Navigator calls with error handling (commented out to avoid key conflicts)
    require("navigator.lspclient.mapping").setup({
        client = client,
        bufnr = bufnr,
    })

    require("navigator.dochighlight").documentHighlight(bufnr)
    require("navigator.codeAction").code_action_prompt(client, bfnr)
    require("navigator.lspclient.highlight").add_highlight()
    require("navigator.lspclient.highlight").config_signs()
    require('navigator.lspclient.lspkind').init()
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- LSP keymaps (using standard LSP functions)
    local keymaps = {
        { mode = 'n', key = 'gr', func = qflist_references },
        { mode = 'n', key = '<c-]>', func = vim.lsp.buf.definition },
        { mode = 'n', key = 'gd', func = vim.lsp.buf.definition },
        { mode = 'n', key = 'gD', func = vim.lsp.buf.declaration },
        { mode = 'n', key = '<leader>/', func = vim.lsp.buf.workspace_symbol },
        { mode = 'n', key = '<C-S-F>', func = vim.lsp.buf.workspace_symbol },
        { mode = 'n', key = 'g0', func = vim.lsp.buf.document_symbol },
        { mode = 'n', key = '<leader>d', func = lsp_hover },
        { mode = 'n', key = 'K', func = lsp_hover },
        { mode = 'n', key = 'gi', func = vim.lsp.buf.implementation },
        { mode = 'n', key = '<Leader>gi', func = vim.lsp.buf.incoming_calls },
        { mode = 'n', key = '<Leader>go', func = vim.lsp.buf.outgoing_calls },
        { mode = 'n', key = 'gt', func = vim.lsp.buf.type_definition },
        { mode = 'n', key = '<C-S-K>', func = vim.lsp.buf.signature_help },
        { mode = 'i', key = '<C-S-K>', func = vim.lsp.buf.signature_help },
        { mode = 'n', key = '<leader>ca', func = vim.lsp.buf.code_action },
        { mode = 'n', key = '<leader>cl', func = vim.lsp.codelens.run },
        { mode = 'n', key = '<leader>la', func = vim.lsp.codelens.run },
        { mode = 'n', key = '<leader>rn', func = vim.lsp.buf.rename },
        { mode = 'v', key = '<leader>ca', func = vim.lsp.buf.code_action },
        { mode = 'n', key = '<C-S-C>', func = vim.lsp.buf.code_action },
        { mode = 'v', key = '<C-S-C>', func = vim.lsp.buf.code_action },
        -- { mode = 'n', key = 'gG', func = vim.diagnostic.setqflist },
        -- { mode = 'n', key = '<leader>G', func = vim.diagnostic.setqflist },
        { mode = 'n', key = 'gL', func = toggle_diagnostics },
        { mode = 'n', key = '<leader>L', func = toggle_diagnostics },
        { mode = 'n', key = 'gE', func = toggle_diagnostics },
        { mode = 'n', key = 'ge', func = toggle_diagnostics },
        { mode = 'n', key = '<leader>ee', func = toggle_diagnostics },
        { mode = 'n', key = '<leader>cf', func = vim.lsp.buf.format },
        { mode = 'v', key = '<leader>cf', func = vim.lsp.buf.format },
        { mode = 'n', key = '<leader>fc', func = vim.lsp.buf.format },
        { mode = 'v', key = '<leader>fc', func = vim.lsp.buf.format },
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

-- Define lspconfig early to avoid nil errors in configuration
local lspconfig = require('lspconfig')

-- allow pylsp_mypy to run in virtual environments
vim.env.PYLSP_MYPY_ALLOW_DANGEROUS_CODE_EXECUTION = 1

-- LSP server configurations
local lsp_config_override = {
    yamlls = {
        settings = {
            yaml = {
                keyOrdering = false,
            },
        },
    },

    helm_ls = {
        root_dir = function(fname)
            local root_files = {
                'Chart.yaml',
                'Chart.lock',
                'helm',
                'charts',
                '.git',
            }
            return lspconfig.util.root_pattern(table.unpack(root_files))(fname) or lspconfig.util.path.dirname(fname)
        end,
        settings = {
            ['helm-ls'] = {
                yamlls = {
                    enabled = false,
                    enabledForFilesGlob = "*.{yaml.yml}",
                    path = "yaml-language-server",
                    config = {
                        keyOrdering = false,
                    },
                },
            },
        },
    },

    gopls = {
        root_dir = function(fname)
            local root_files = {
                'go.mod',
                'go/go.mod',
                'go.work',
                '.git',
            }
            return lspconfig.util.root_pattern(table.unpack(root_files))(fname) or lspconfig.util.path.dirname(fname)
        end,
    },

    golangci_lint_ls = {},

    terraformls = {
        root_dir = function(fname)
            local root_files = {
                '.terraform_root',
                '.terraform',
                '.git',
            }
            return lspconfig.util.root_pattern(table.unpack(root_files))(fname) or lspconfig.util.path.dirname(fname)
        end,
    },

    pylsp = {
        settings = {
            pylsp = {
                plugins = {
                    pycodestyle = {
                        enabled = true,
                        ignore = {
                            'E402',
                            'E501',
                            'E731',
                            'W503',
                            'W504',
                        },
                    },
                    jedi_completion = {
                        enabled = true,
                    },
                    jedi = {
                      environment = vim.env.VIRTUAL_ENV or ".venv/",
                    },

                    pylsp_mypy = {
                        enabled = true,
                        live_mode = false, -- only on save
                        strict = true,
                        ignore_missing_imports = true,
                        ["follow-imports"] = "silent",
                         mypy_command = {
                            "mypy",
                            "--strict",
                            "--follow-imports=silent",
                            "--ignore-missing-imports",
                         },
                    },
                },
            },
        },
    },

    pyright = {
        on_new_config = function(new_config, dir)
            if dir_has_file(dir, "poetry.lock") then
                new_config.cmd = { "poetry", "run", "pyright-langserver", "--stdio" }
            elseif dir_has_file(dir, "Pipfile") then
                new_config.cmd = { "pipenv", "run", "pyright-langserver", "--stdio" }
            end
        end,
    },
}

-- Set default metatable for lsp_config_override
setmetatable(lsp_config_override, { __index = function() return {} end })

local function get_lspconfig(server_name)
    local opts = {
        on_attach = lsp_attach,
        capabilities = lsp_capabilities,
    }

    if lsp_config_override[server_name] ~= false then
        opts = vim.tbl_extend('force', opts, lsp_config_override[server_name])
    end

    return opts
end

-- Mason handlers
local mason_handlers = {
    function(server_name)
        lspconfig[server_name].setup(get_lspconfig(server_name))
    end,
}

-- Try to use setup_handlers, if not available setup servers manually
local ok, mason_lspconfig = pcall(require, 'mason-lspconfig')
if ok and mason_lspconfig.setup_handlers then
    mason_lspconfig.setup_handlers(mason_handlers)
else
    -- Manually setup servers if setup_handlers is not available
    local servers = {
        "vimls", "lua_ls", "terraformls", "jqls", "taplo", "yamlls",
        "helm_ls", "pylsp", "jsonls", "gopls", "golangci_lint_ls",
        "dockerls", "bashls", "ts_ls"
    }
    for _, server_name in ipairs(servers) do
        if lspconfig[server_name] then
            lspconfig[server_name].setup(get_lspconfig(server_name))
        end
    end
end

-- Treesitter setup
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

vim.g.skip_ts_context_commentstring_module = true

-- VimTex
vim.g.vimtex_view_method = 'zathura'

-- EasyAlign
keymap('v', '<Enter>', '<Plug>(EasyAlign)')

-- EasyAlign custom delimiters
vim.g.easy_align_delimiters = {
    s = {
        pattern = '\\C[a-z]',
        left_margin = 1,
        right_margin = 0,
        align = 'r'
    },
    ['?'] = {
        pattern = '[?]',
        left_margin = 0,
        right_margin = 0,
        indentation = 's',
        align = 'l'
    },
    [':'] = {
        pattern = ':',
        left_margin = 1,
        right_margin = 1,
        stick_to_left = 0
    },
    ['['] = {
        pattern = ']',
        left_margin = 1,
        right_margin = 0,
        stick_to_left = 0
    },
    [']'] = {
        pattern = ']',
        left_margin = 1,
        right_margin = 0,
        stick_to_left = 0
    },
    ['('] = {
        pattern = ')',
        left_margin = 1,
        right_margin = 0,
        stick_to_left = 0
    },
    [')'] = {
        pattern = ')',
        left_margin = 1,
        right_margin = 0,
        stick_to_left = 0
    },
    ['{'] = {
        pattern = '}',
        left_margin = 1,
        right_margin = 0,
        stick_to_left = 0
    },
    ['}'] = {
        pattern = '}',
        left_margin = 1,
        right_margin = 0,
        stick_to_left = 0
    },
    ['.'] = {
        pattern = '[.]',
        left_margin = 1,
        right_margin = 1,
        stick_to_left = 0
    }
}

-- VimMarkdown
vim.g.vim_markdown_conceal = 0
vim.g.vim_markdown_folding_style_pythonic = 1

-- Undo Tree
keymap('n', '<F3>', ':UndotreeToggle<CR>')
vim.g.undotree_WindowLayout = 2
vim.g.undotree_SetFocusWhenToggle = 1

-- Better Whitespace
local function delete_whitespace()
    local save_pos = vim.fn.getpos(".")
    vim.cmd('StripWhitespace')
    vim.fn.setpos(".", save_pos)
end

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = delete_whitespace
})

-- vim-fubitive
vim.g.fubitive_domain_pattern = 'code\\.squarespace\\.net'

-- Tagbar
keymap('n', '<F2>', ':TagbarToggle<CR>', { silent = true })
vim.g.tagbar_map_togglefold = '<Space>'
vim.g.tagbar_autofocus = 1

-- which-key
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

-- debugprint
require("debugprint").setup({
    move_to_debugline = true,
    display_snippet = true,
    display_counter = true,
    print_tag = "DEBUGPRINT",
})

keymap("n", "<leader>dD", function()
    return require("debugprint").debugprint({ above = true })
end, { expr = true })

keymap("n", "<leader>dd", function()
    return require("debugprint").debugprint({})
end, { expr = true })

keymap("n", "<leader>dV", function()
    return require("debugprint").debugprint({ above = true, variable = true })
end, { expr = true })

keymap("n", "<leader>dv", function()
    return require("debugprint").debugprint({ variable = true })
end, { expr = true })

-- gitsigns
require("gitsigns").setup({
    signcolumn = true,
    numhl = true,
    current_line_blame = true,
    current_line_blame_formatter = '[<author_mail>, <author_time:%Y-%m-%d> [<abbrev_sha>] - <summary>]',
    current_line_blame_formatter_nc = '[Not committed yet]',
    trouble = true,
})

keymap('n', '<leader>gb', require('gitsigns').blame_line)
keymap('n', '<leader>bl', require('gitsigns').blame_line)

-- copilot - disabled due to persistent serialization errors
vim.defer_fn(function()
    local okydoky, copilot = pcall(require, "copilot")
    if okydoky then
        copilot.setup({
            suggestion = {
                enabled = true,
                auto_trigger = false,
                keymap = {
                    accept = "<C-t>",
                },
            },
            panel = { enabled = false },
        })
    end
end, 1000)  -- Delay setup by 1 second

-- ============================================================================
-- Auto Commands
-- ============================================================================

-- Disable paste mode when leaving insert mode
vim.api.nvim_create_autocmd("InsertLeave", {
    pattern = "*",
    command = "set nopaste"
})

-- Automatically reload init.lua when it's saved
vim.api.nvim_create_augroup("AutoReloadVimRC", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
    group = "AutoReloadVimRC",
    pattern = vim.fn.stdpath("config") .. "/init.lua",
    command = "luafile " .. vim.fn.stdpath("config") .. "/init.lua"
})

-- Return to same line when reopening a file
vim.api.nvim_create_augroup("line_return", { clear = true })
vim.api.nvim_create_autocmd("BufReadPost", {
    group = "line_return",
    pattern = "*",
    callback = function()
        local line = vim.fn.line("'\"")
        if line > 0 and line <= vim.fn.line("$") then
            vim.cmd('normal! g`"zvzz')
        end
    end
})

-- Don't update folds in insert mode
vim.api.nvim_create_augroup("NoInsertFolding", { clear = true })
vim.api.nvim_create_autocmd("InsertEnter", {
    group = "NoInsertFolding",
    pattern = "*",
    callback = function()
        vim.w.oldfdm = vim.opt_local.foldmethod[0]
        vim.opt_local.foldmethod = 'manual'
    end
})
vim.api.nvim_create_autocmd("InsertLeave", {
    group = "NoInsertFolding",
    pattern = "*",
    callback = function()
        if vim.w.oldfdm then
            vim.opt_local.foldmethod = vim.w.oldfdm
            vim.w.oldfdm = nil
        end
        vim.cmd('normal! zv')
    end
})

-- Markdown filetype
vim.api.nvim_create_augroup("MarkdownFiletype", { clear = true })
vim.api.nvim_create_autocmd({"BufNewFile", "BufFilePre", "BufRead"}, {
    group = "MarkdownFiletype",
    pattern = "*.md",
    command = "set filetype=markdown"
})

-- Auto save and read
vim.api.nvim_create_augroup("autoSaveAndRead", { clear = true })
vim.api.nvim_create_autocmd({"TextChanged", "InsertLeave", "FocusLost"}, {
    group = "autoSaveAndRead",
    pattern = "*",
    command = "silent! wall"
})
vim.api.nvim_create_autocmd("CursorHold", {
    group = "autoSaveAndRead",
    pattern = "*",
    command = "silent! checktime"
})

-- Fix treesitter folding on file open
vim.api.nvim_create_augroup("TreesitterFolding", { clear = true })
vim.api.nvim_create_autocmd({"BufRead", "BufWinEnter"}, {
    group = "TreesitterFolding",
    pattern = "*",
    callback = function()
        vim.schedule(function()
            if vim.wo.foldmethod == 'expr' and vim.wo.foldexpr:match('treesitter') then
                vim.cmd('normal! zxzvzz')  -- Recalculate folds, open around cursor, and center
            end
        end)
    end
})

-- ============================================================================
-- Folding
-- ============================================================================

opt.foldmethod = 'expr'
opt.foldexpr = 'nvim_treesitter#foldexpr()'
opt.foldenable = true
opt.foldlevelstart = 0

-- Space to toggle folds
keymap({'n', 'v'}, '<Space>', 'za')
-- Shift+Space to toggle folds recursively
keymap({'n', 'v'}, '<Enter>', 'zA')

-- Make zO recursively open whatever fold we're in
keymap('n', 'zO', 'zczO')

-- Focus the current line
keymap('n', '<c-z>', 'mzzMzvzz15<c-e>`z:Pulse<cr>')

-- Custom fold text
local function my_fold_text()
    local line = vim.fn.getline(vim.v.foldstart) or ""

    local nucolwidth = (vim.o.foldcolumn or 0) + (vim.o.number and (vim.o.numberwidth or 4) or 0)
    local windowwidth = vim.fn.winwidth(0) - nucolwidth - 3
    local foldedlinecount = vim.v.foldend - vim.v.foldstart

    -- expand tabs into spaces
    local onetab = string.rep(' ', vim.o.tabstop or 4)
    line = line:gsub('\t', onetab)

    local count_str = tostring(foldedlinecount)
    local max_line_len = math.max(0, windowwidth - 2 - count_str:len())
    line = line:sub(1, max_line_len)
    local fillcharcount = math.max(0, windowwidth - line:len() - count_str:len())
    return line .. '…' .. string.rep(" ", fillcharcount) .. count_str .. '…' .. ' '
end

opt.foldtext = 'v:lua.my_fold_text()'
_G.my_fold_text = my_fold_text

-- ============================================================================
-- Filetype-specific Configuration
-- ============================================================================

-- Go
vim.api.nvim_create_augroup("ft_go", { clear = true })

-- Auto formatting on save
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
    lsp_cfg = false,
    trouble = true,
})

vim.api.nvim_create_autocmd("FileType", {
    group = "ft_go",
    pattern = "go",
    callback = function()
        local opts = { buffer = true }
        -- Recursive toggle
        keymap({'n', 'v'}, '<Space>', 'zA', opts)

        -- Alternate between test files
        vim.api.nvim_buf_create_user_command(0, 'A', 'GoAlt', { bang = true })
        vim.api.nvim_buf_create_user_command(0, 'AV', 'GoAltV', { bang = true })
        vim.api.nvim_buf_create_user_command(0, 'AS', 'GoAltS', { bang = true })

        -- Go build and test
        keymap('n', '<leader>b', ':GoBuild %:h<CR>', opts)
        keymap('n', '<Leader>t', ':GoTestFile<CR>', opts)
        keymap('n', '<Leader>tf', ':GoTestFunc<CR>', opts)

        -- Abbreviations
        vim.cmd('iabbrev <buffer> === :=')
        vim.cmd('iabbrev <buffer> !! !=')
        vim.cmd('iabbrev <buffer> importlogrus log "github.com/sirupsen/logrus"')
        vim.cmd('iabbrev <buffer> importlog log "github.com/sirupsen/logrus"')
        vim.cmd('iabbrev <buffer> importspew "github.com/davecgh/go-spew/spew"')
        vim.cmd('iabbrev <buffer> importassert "github.com/stretchr/testify/assert"')
        vim.cmd('iabbrev <buffer> importmetav1 metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"')
    end
})

-- Helm (yaml)
vim.api.nvim_create_augroup("ft_helm", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    group = "ft_helm",
    pattern = "helm",
    callback = function()
        vim.opt_local.commentstring = '# %s'
    end
})

-- Javascript
vim.api.nvim_create_augroup("ft_javascript", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    group = "ft_javascript",
    pattern = "javascript",
    callback = function()
        local opts = { buffer = true }
        keymap({'n', 'v'}, '<Space>', 'zA', opts)
    end
})

-- Typescript
vim.api.nvim_create_augroup("ft_typescript", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    group = "ft_typescript",
    pattern = "typescript",
    callback = function()
        local opts = { buffer = true }
        keymap({'n', 'v'}, '<Space>', 'zA', opts)

        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.expandtab = true
    end
})

-- JSON
vim.api.nvim_create_augroup("ft_json", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    group = "ft_json",
    pattern = "json",
    callback = function()
        local opts = { buffer = true }
        keymap({'n', 'v'}, '<Space>', 'zA', opts)
    end
})

-- jsonnet
vim.api.nvim_create_augroup("ft_jsonnet", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    group = "ft_jsonnet",
    pattern = "jsonnet",
    callback = function()
        local opts = { buffer = true }
        keymap({'n', 'v'}, '<Space>', 'zA', opts)

        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.expandtab = true
        vim.opt_local.commentstring = '# %s'
    end
})

-- LaTeX
vim.api.nvim_create_augroup("ft_latex", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    group = "ft_latex",
    pattern = "latex",
    callback = function()
        local opts = { buffer = true }
        keymap({'n', 'v'}, '<Space>', 'zA', opts)
        vim.opt_local.textwidth = 80
    end
})

-- Markdown
vim.api.nvim_create_augroup("ft_markdown", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    group = "ft_markdown",
    pattern = "markdown",
    callback = function()
        local opts = { buffer = true }
        vim.opt_local.textwidth = 80

        -- Use <localleader>1/2/3/4 to add headings
        keymap('n', '<localleader>1', 'yypVr=:redraw<cr>', opts)
        keymap('n', '<localleader>2', 'yypVr-:redraw<cr>', opts)
        keymap('n', '<localleader>3', 'mzI###<space><esc>`zllll', opts)
        keymap('n', '<localleader>4', 'mzI####<space><esc>`zlllll', opts)
    end
})

vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
    group = "ft_markdown",
    pattern = "*.m*down",
    callback = function()
        vim.opt_local.filetype = 'markdown'
        vim.opt_local.foldlevel = 1
    end
})

-- Python
vim.api.nvim_create_augroup("ft_python", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    group = "ft_python",
    pattern = "python",
    callback = function()
        -- local opts = { buffer = true }
        -- keymap({'n', 'v'}, '<Space>', 'zA', opts)
        vim.opt_local.define = '^\\s*\\(def\\|class\\)'
    end
})

-- Vim
vim.api.nvim_create_augroup("ft_vim", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    group = "ft_vim",
    pattern = "vim",
    callback = function()
        vim.opt_local.foldmethod = 'marker'
    end
})

vim.api.nvim_create_autocmd("FileType", {
    group = "ft_vim",
    pattern = "help",
    callback = function()
        vim.opt_local.textwidth = 80
    end
})

-- ============================================================================
-- Colorscheme
-- ============================================================================

opt.background = 'dark'
vim.cmd('highlight clear')

if vim.fn.exists('syntax_on') == 1 then
    vim.cmd('syntax reset')
end

require("tokyonight").setup({
    style = "night",
    transparent = true,
    terminal_colors = true,
    styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
        sidebars = "dark",
        floats = "dark",
    },
})

vim.cmd('colorscheme tokyonight-night')

