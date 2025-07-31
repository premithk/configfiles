-- init.lua
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ============================================================================
-- ===                           CORE OPTIONS                               ===
-- ============================================================================
vim.g.mapleader = ','
vim.g.maplocalleader = ','

-- Editing Options
vim.opt.clipboard = 'unnamed'     -- Yank and paste with the system clipboard
vim.opt.hidden = true             -- Hides buffers instead of closing them
vim.opt.expandtab = true          -- Insert spaces when TAB is pressed
vim.opt.softtabstop = 2           -- Change number of spaces that a <Tab> counts for
vim.opt.shiftwidth = 2            -- Indentation amount for < and > commands
vim.opt.wrap = false              -- Do not wrap long lines
vim.opt.cmdheight = 1             -- Only one line for command line
vim.opt.shortmess:append('c')     -- Don't give completion messages
vim.opt.cursorline = true         -- Highlight the current line
vim.opt.termguicolors = true      -- Enable true color support
vim.opt.winblend = 10             -- Set floating window to be slightly transparent
vim.opt.splitbelow = true         -- Set preview window to appear at bottom
vim.opt.fillchars:append({ vert = ' ' }) -- Hide vertical split character

-- UI Options
vim.opt.number = true             -- Enable line numbers
vim.opt.relativenumber = true     -- Enable relative line numbers
vim.opt.showmode = false          -- Don't display mode in command line (airline shows it)
vim.opt.showcmd = false           -- Don't show last command
vim.opt.ruler = false             -- Disable line/column number in status line

-- Search Options
vim.opt.ignorecase = true         -- Ignore case when searching
vim.opt.smartcase = true          -- Be case-sensitive if search has uppercase letters
vim.opt.autoread = true           -- Automatically re-read file if changed outside of vim

-- Backup/Undo Options
vim.opt.undofile = true
vim.opt.undolevels = 3000
vim.opt.undoreload = 10000
vim.opt.backup = true
vim.opt.backupdir = vim.fn.stdpath("data") .. "/backup"
vim.opt.swapfile = false

-- Font
vim.o.guifont = "Hack Nerd Font:h16"

-- ============================================================================
-- ===                           KEY MAPPINGS                               ===
-- ============================================================================
local map = vim.keymap.set
-- Quick window switching
map('n', '<C-h>', '<C-w>h', { silent = true, desc = "Window Left" })
map('n', '<C-j>', '<C-w>j', { silent = true, desc = "Window Down" })
map('n', '<C-k>', '<C-w>k', { silent = true, desc = "Window Up" })
map('n', '<C-l>', '<C-w>l', { silent = true, desc = "Window Right" })

-- Page up/down with Space and -
map('n', '<Space>', '<PageDown>', { noremap = true, silent = true })
map('n', '-', '<PageUp>', { noremap = true, silent = true })

-- Search shortcuts
map('n', '<leader>h', ':%s///<left><left>', { desc = "Find and Replace" })
map('n', '<leader>/', ':nohlsearch<CR>', { silent = true, desc = "Clear Search Highlight" })

-- Save with sudo
vim.cmd([[cmap w!! w !sudo tee %]])

-- Paste over selection without yanking
map('v', '<leader>p', '"_dP', { desc = "Paste without yanking" })

-- ============================================================================
-- ===                           PLUGIN SETUP                               ===
-- ============================================================================
require('lazy').setup({
  -- Use SSH for cloning plugins to avoid HTTPS authentication issues
  git = {
    url_format = "git@github.com:%s.git",
  },

  -- Colorschemes
  { 'folke/tokyonight.nvim', branch = 'main', lazy = false, priority = 1000,
    config = function()
      require('tokyonight').setup({
        transparent = true,
        styles = {
          sidebars = "transparent",
          floats = "transparent",
        },
        on_colors = function(colors)
          colors.bg_statusline = "#6699CC"
          colors.fg_statusline = "#16252b"
          colors.bg_statusline_inactive = "#16252b"
          colors.fg_statusline_inactive = "#16252b"
          colors.bg_visual = "#444444"
        end
      })
      vim.cmd.colorscheme 'tokyonight'
    end
  },
  'arcticicestudio/nord-vim',
  'morhetz/gruvbox',
  'liuchengxu/space-vim-dark',
  'EdenEast/nightfox.nvim',

  -- Statusline
  { 'vim-airline/vim-airline' },
  { 'vim-airline/vim-airline-themes',
    dependencies = { 'vim-airline/vim-airline' },
    config = function()
      vim.g.airline_theme = 'nord_minimal'
      vim.g['airline#extensions#tabline#formatter'] = 'unique_tail_improved'
    end,
  },

  -- Icons
  { 'nvim-tree/nvim-web-devicons', config = function() require('nvim-web-devicons').setup() end },

  -- File Explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        window = {
          position = "right",
        },
      })
      vim.keymap.set('n', '<leader>n', ':Neotree toggle<CR>', { desc = "Toggle NeoTree" })
      vim.keymap.set('n', '<leader>f', ':Neotree find<CR>', { desc = "NeoTree Find File" })
    end
  },

  -- Fuzzy Finder
  { 'nvim-telescope/telescope.nvim',
    tag = '0.1.5',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local actions = require('telescope.actions')
      require('telescope').setup({
        defaults = {
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-h>"] = actions.preview_scrolling_up,
              ["<C-l>"] = actions.preview_scrolling_down,
              ["<C-o>"] = actions.select_default,
            },
          },
        },
        preview = {
          hide_on_startup = true -- or even set `previewer = false` entirely
        }
      })
      map('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { desc = "Find Files" })
      map('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', { desc = "Live Grep" })
      map('n', '<leader>fb', '<cmd>Telescope buffers<cr>', { desc = "Find Buffers" })
      map('n', '<leader>fh', '<cmd>TFuzzy Finderelescope help_tags<cr>', { desc = "Help Tags" })
    end
  },

  -- LSP, Completion, and Snippets
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    lazy = false,
    dependencies = {
        -- LSP Support
        {'neovim/nvim-lspconfig'},
        {'williamboman/mason.nvim'},
        {'williamboman/mason-lspconfig.nvim'},

        -- Autocompletion
        {'hrsh7th/nvim-cmp'},
        {'hrsh7th/cmp-nvim-lsp'},
        {'hrsh7th/cmp-buffer'},
        {'hrsh7th/cmp-path'},
        {'saadparwaiz1/cmp_luasnip'},
        {'hrsh7th/cmp-nvim-lua'},

        -- Snippets
        {'L3MON4D3/LuaSnip'},
        {'rafamadriz/friendly-snippets'},
    },
    config = function()
        local lsp_zero = require('lsp-zero')
        lsp_zero.on_attach(function(client, bufnr)
            local telescope_builtin = require('telescope.builtin')
            -- LSP Keymaps (maintaining your shortcuts)
            map('n', 'gd', vim.lsp.buf.definition, {buffer=bufnr, desc="Go to Definition"})
            map('n', 'K', vim.lsp.buf.hover, {buffer=bufnr, desc="Hover Documentation"})
            map('n', 'gi', vim.lsp.buf.implementation, {buffer=bufnr, desc="Go to Implementation"})
            map('n', 'gr', telescope_builtin.lsp_references, {buffer=bufnr, desc="Go to References"})
            map('n', 'gy', vim.lsp.buf.type_definition, {buffer=bufnr, desc="Go to Type Definition"})
            map('n', '<leader>rn', vim.lsp.buf.rename, {buffer=bufnr, desc="Rename Symbol"})
            map('n', '<leader>ac', vim.lsp.buf.code_action, {buffer=bufnr, desc="Code Action"})
            map('n', '[g', vim.diagnostic.goto_prev, {desc="Previous Diagnostic"})
            map('n', ']g', vim.diagnostic.goto_next, {desc="Next Diagnostic"})
            map('n', '<leader>qf', vim.diagnostic.open_float, {desc="Open Diagnostics Float"})
        end)

        require('mason').setup({})
        require('mason-lspconfig').setup({
            ensure_installed = { 'pyright', 'ts_ls', 'eslint', 'html', 'cssls', 'bashls', 'jsonls', 'lua_ls' },
            handlers = {
                lsp_zero.default_setup,
            }
        })

        -- Configure nvim-cmp
        local cmp = require('cmp')
        cmp.setup({
            sources = {
                {name = 'nvim_lsp'},
                {name = 'luasnip'},
                {name = 'buffer'},
                {name = 'path'},
            },
            mapping = {
                ['<CR>'] = cmp.mapping.confirm({select = true}),
                ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'}),
                ['<S-Tab>'] = cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'}),
                ['<C-Space>'] = cmp.mapping.complete(),
            },
        })
    end
  },
  -- AI Assistants
  { 'codota/tabnine-nvim', build = './dl_binaries.sh' },
  { 'github/copilot.vim' },

  -- Treesitter for syntax highlighting
  { 'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require'nvim-treesitter.configs'.setup {
        ensure_installed = {
          "c", "lua", "vim", "vimdoc", "query", "javascript", "typescript", "python", "tsx", "html", "css", "json", "bash", "markdown", "markdown_inline"
        },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = { enable = true },
        fold = { enable = true },
      }
      vim.opt.foldmethod = 'expr'
      vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
      vim.opt.foldenable = false
    end
  },

  -- Git integration
  'tpope/vim-fugitive',
  'mhinz/vim-signify',
  'APZelos/blamer.nvim',

  -- Commenting
  { 'preservim/nerdcommenter',
    config = function()
      vim.g.NERDSpaceDelims = 1
      vim.g.NERDCompactSexyComs = 1
      vim.g.NERDDefaultAlign = 'left'
      vim.g.NERDCommentEmptyLines = 1
      vim.g.NERDTrimTrailingWhitespace = 1
      vim.g.NERDToggleCheckAllLines = 1
    end
  },

  -- Syntax Highlighting
  'HerringtonDarkholme/yats.vim', -- Typescript
  'mxw/vim-jsx', -- React JSX
  'chr4/nginx.vim', -- Nginx
  'othree/javascript-libraries-syntax.vim',
  'othree/yajs.vim',

  -- Other utilities
  'tpope/vim-surround',
  'rstacruz/vim-closer',
  'easymotion/vim-easymotion',
  { 'heavenshell/vim-jsdoc', config = function() map('n', '<leader>z', ':JsDoc<CR>', { desc = "Generate JSDoc" }) end },
  { 'ntpeters/vim-better-whitespace', config = function() map('n', '<leader>y', ':StripWhitespace<CR>', { desc = "Strip Whitespace" }) end },
  'shift-d/scratch.nvim',
  'junegunn/limelight.vim',
  'junegunn/goyo.vim',
})

-- ============================================================================
-- ===                        CUSTOM HIGHLIGHTS                             ===
-- ============================================================================
-- Highlight trailing whitespace
vim.api.nvim_set_hl(0, 'Trail', { bg = 'red' })
vim.fn.matchadd('Trail', '\\s\\+$', 100)

-- Custom highlight for preview window
vim.api.nvim_create_autocmd("WinEnter", {
  pattern = "*",
  callback = function()
    if vim.wo.previewwindow then
      vim.wo.winhighlight = "Normal:MarkdownError"
    end
  end,
})

-- Spellcheck for markdown
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = "*.md",
  command = "setlocal spell",
})

