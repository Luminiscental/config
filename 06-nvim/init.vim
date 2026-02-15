
let mapleader = '\'

" vista.vim
let g:vista_sidebar_width=50

" markdown preview config
let g:mkdp_browser = 'firefox'

let g:lexima_enable_newline_rules = 1

" fuzzy ignore
let g:ctrlp_custom_ignore = {
  \ 'dir': '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ }

let g:tex_flavor = 'latex'
let g:vimtex_view_method = 'zathura'

function! UpdateRemotePlugins(...)
  let &rtp=&rtp
  UpdateRemotePlugins
endfunction

call plug#begin()

  Plug 'https://tpope.io/vim/sensible.git'
  Plug 'ctrlpvim/ctrlp.vim'
  Plug 'tpope/vim-surround'
  Plug 'machakann/vim-highlightedyank'
  Plug 'plasticboy/vim-markdown'
  Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
  Plug 'lervag/vimtex'
  Plug 'cohama/lexima.vim'
  Plug 'tpope/vim-repeat'
  Plug 'neovim/nvim-lspconfig'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/vim-vsnip'
  Plug 'hrsh7th/cmp-vsnip'
  Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
  Plug 'nvim-lua/plenary.nvim'
  Plug 'https://codeberg.org/andyg/leap.nvim'
  Plug 'tpope/vim-fugitive'
  Plug 'lewis6991/gitsigns.nvim'
  Plug 'SmiteshP/nvim-navic'
  Plug 'nvim-lualine/lualine.nvim'
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'arkav/lualine-lsp-progress'
  Plug 'Luminiscental/autumn256.vim'
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'kevinhwang91/nvim-bqf'
  Plug 'mbbill/undotree'

call plug#end()

" lexima rules
call lexima#add_rule({'char': '<', 'at': '[^< ]\%#', 'input_after': '>', 'mode': 'i', 'filetype': ['rust', 'c', 'cpp']})
call lexima#add_rule({'char': '>', 'at': '\%#>', 'leave': 1, 'filetype': ['rust', 'c', 'cpp']})
call lexima#add_rule({'char': '<BS>', 'at': '<\%#>', 'delete': 1, 'filetype': ['rust', 'c', 'cpp']})

call lexima#add_rule({'char': '$', 'input_after': '$', 'filetype': 'tex'})
call lexima#add_rule({'char': '$', 'at': '\%#\$', 'leave': 1, 'filetype': 'tex'})
call lexima#add_rule({'char': '<BS>', 'at': '\$\%#\$', 'delete': 1, 'filetype': 'tex'})

call lexima#add_rule({'char': '{', 'at': '\\\%#', 'input': '{', 'input_after': '\}', 'mode': 'i', 'filetype': 'tex'})
call lexima#add_rule({'char': '\', 'at': '\%#\\}', 'leave': 1, 'filetype': 'tex'})
call lexima#add_rule({'char': '<BS>', 'at': '\\{\%#\\}', 'input': '<BS><DEL><DEL>', 'filetype': 'tex'})

" workflow mappings
nnoremap - dd
nnoremap ; :
vnoremap ; :
nnoremap <leader>v :Vista!!<CR>
nnoremap <leader>t :NvimTreeToggle<CR>

" get the syntax flags under the cursor
nnoremap <leader>sp :call <SID>SynStack()<CR>
function! <SID>SynStack()
    if !exists("*synstack")
        return
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" markdown preview mappings
nnoremap <leader>mp <Plug>MarkdownPreviewToggle

" LSP
lua <<EOF
  -- Setup nvim-cmp.
  local cmp = require'cmp'

  local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
  end

  local feedkey = function(key, mode)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
  end

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
      end,
    },
    mapping = {
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          local entries = cmp.get_entries()
          cmp.select_next_item({ behaviour = cmp.SelectBehavior.Select })
          if #entries == 1 then
            cmp.confirm()
          end
        elseif vim.fn["vsnip#available"](1) == 1 then
          feedkey("<Plug>(vsnip-expand-or-jump)", "")
        elseif has_words_before() then
          cmp.complete()
        else
          fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
        end
      end, { "i", "s" }),

      ["<S-Tab>"] = cmp.mapping(function()
        if cmp.visible() then
          cmp.select_prev_item({ behaviour = cmp.SelectBehavior.Select })
        elseif vim.fn["vsnip#jumpable"](-1) == 1 then
          feedkey("<Plug>(vsnip-jump-prev)", "")
        end
      end, { "i", "s" }),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
      { name = 'crates' },
    }, {
      { name = 'buffer' },
    }),
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
  })

  -- Setup lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities()

  local navic = require'nvim-navic'

  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
      local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
      navic.attach(client, ev.buf)

      -- Buffer local mappings.
      -- See `:help vim.lsp.*` for documentation on any of the below functions
      local opts = { buffer = ev.buf }
      vim.keymap.set('n', '<leader>ld', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
      vim.keymap.set('n', '<leader>lh', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
      vim.keymap.set('n', '<leader>ln', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
      vim.keymap.set('n', '<leader>lr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
      vim.keymap.set('n', '<leader>le', '<cmd>lua vim.diagnostic.show()<CR>', opts)
      vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
      vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
    end,
  })

  vim.lsp.enable('texlab')

  -- diagnostic signs
  vim.diagnostic.config({
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = '󰅚 ',
        [vim.diagnostic.severity.WARN] = '',
        [vim.diagnostic.severity.HINT] = '󰌶 ',
        [vim.diagnostic.severity.INFO] = ' ',
      },
      numhl = {
        [vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
        [vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
        [vim.diagnostic.severity.HINT] = 'DiagnosticSignHint',
        [vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
      },
    },
  })

  -- git signs
  require'gitsigns'.setup {
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      map('n', ']h', function()
        if vim.wo.diff then return ']h' end
        vim.schedule(function() gs.next_hunk() end)
        return '<Ignore>'
      end, {expr=true})

      map('n', '[h', function()
        if vim.wo.diff then return '[h' end
        vim.schedule(function() gs.prev_hunk() end)
        return '<Ignore>'
      end, {expr=true})

      map('n', '<leader>hs', gs.stage_hunk)
      map('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
      map('n', '<leader>hu', gs.undo_stage_hunk)
      map('n', '<leader>hr', gs.reset_hunk)
      map('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
      map('n', '<leader>hp', gs.preview_hunk)
      map('n', '<leader>hb', gs.toggle_current_line_blame)
    end,
    signs = {
      add          = {text = '+'},
      change       = {text = '|'},
      delete       = {text = '-'},
      topdelete    = {text = '‾'},
      changedelete = {text = '~'},
    },
    signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
    numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
    linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
    watch_gitdir = {
      interval = 1000,
      follow_files = true
    },
    attach_to_untracked = true,
    current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
      delay = 1000,
      ignore_whitespace = false,
    },
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil, -- Use default
    max_file_length = 40000,
    preview_config = {
      -- Options passed to nvim_open_win
      border = 'single',
      style = 'minimal',
      relative = 'cursor',
      row = 0,
      col = 1
    },
  }

  require'lualine'.setup {
    options = {
      icons_enabled = true,
      theme = require'autumn256.lualine_theme',
      component_separators = { left = '|', right = '|'},
      section_separators = { left = '', right = ''},
      disabled_filetypes = {},
      always_divide_middle = true,
    },
    sections = {
      lualine_a = {'mode'},
      lualine_b = {'filename', 'diff', 'diagnostics'},
      lualine_c = {
        { navic.get_location, cond = navic.is_available },
        'lsp_progress'
      },
      lualine_x = {'encoding', 'fileformat', 'filetype'},
      lualine_y = {'progress'},
      lualine_z = {'location'}
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {'filename'},
      lualine_x = {'location'},
      lualine_y = {},
      lualine_z = {}
    },
    tabline = {},
    extensions = {}
  }

  --leap
  vim.keymap.set({'n', 'x', 'o'}, 's', '<Plug>(leap)')
  vim.keymap.set({'n', 'x', 'o'}, 'S', '<Plug>(leap-backward)')
EOF

" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect

" format buffer
nnoremap <F1> <cmd>lua vim.lsp.buf.format { async = true }<CR>
" remove highlights
nnoremap <F2> :noh<CR>
" remove trailing whitespace
nnoremap <F3> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>
" adjust view
nnoremap <F4> zt5<C-y>

" navigation:

" gitgutter
nnoremap ]h <Plug>(GitGutterNextHunk)
nnoremap [h <Plug>(GitGutterPrevHunk)

" move tab
nnoremap <F8>  :tabp<CR>
nnoremap <F9>  :tabn<CR>

" remap snippet completion
inoremap <expr> <C-L> vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<C-L>'
snoremap <expr> <C-L> vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<C-L>'
inoremap <expr> <C-K> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<C-K>'
snoremap <expr> <C-K> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<C-K>'

" sane buffers
set hidden
set splitbelow
set splitright

" cached undo
set undodir=~/.vimdid
set undofile

" gui colors
set termguicolors

" show current line number and relative numbers
set number
set relativenumber

" use a sign column with space for 3 signs
set signcolumn=yes:3

" use 2 lines for commands
set cmdheight=2

" use autumn256 colorscheme
colorscheme autumn256

" color column at 80
set colorcolumn=80

" lualine shows the mode too so don't bother
set noshowmode

" disable mouse to stop eating inputs from terminal
set mouse=

" copypasting
set clipboard+=unnamedplus

" don't fold stuff in markdown
au FileType markdown setlocal nofoldenable

" sane tabs
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

" vim:set ft=vim et sw=2:
