
let mapleader = '\'

" vista.vim
let g:vista_sidebar_width=50

" better python syntax
let g:python_highlight_all = 1

" horrendous ) overrides in insert mode begone
let g:sexp_enable_insert_mode_mappings = 0

" better java syntax
let g:java_highlight_functions = 1
let g:java_highlight_java_lang_ids = 1

" markdown preview config
let g:mkdp_browser = 'firefox'

let g:lexima_enable_newline_rules = 1

" fuzzy ignore
let g:ctrlp_custom_ignore = {
  \ 'dir': '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ }

" lightline config
let g:lightline = {
      \ 'colorscheme': 'jellybeans',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'lsp_status', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ }

let g:tex_flavor = 'latex'
let g:vimtex_compiler_progname = 'nvr'
let g:vimtex_syntax_conceal_default = 1


" tex pdf previews
let g:vimtex_view_method='mupdf'

" latex formatting
let g:vimtex_format_enabled=1

call plug#begin()

  Plug 'ctrlpvim/ctrlp.vim'
  Plug 'vim-python/python-syntax'
  Plug 'tpope/vim-surround'
  Plug 'scrooloose/nerdtree'
  Plug 'machakann/vim-highlightedyank'
  Plug 'cespare/vim-toml'
  Plug 'rust-lang/rust.vim'
  Plug 'plasticboy/vim-markdown'
  Plug 'iamcco/markdown-preview.nvim', {'for': ['markdown', 'pandoc.markdown', 'rmd'], 'do': 'cd app & yarn install'}
  Plug 'neovimhaskell/haskell-vim'
  Plug 'lervag/vimtex'
  Plug 'cohama/lexima.vim'
  Plug 'tikhomirov/vim-glsl'
  Plug 'honza/vim-snippets'
  Plug 'tpope/vim-repeat'
  Plug 'guns/vim-sexp'
  Plug 'tpope/vim-sexp-mappings-for-regular-people'
  Plug 'liuchengxu/vista.vim'
  Plug 'neovim/nvim-lspconfig'
  Plug 'nvim-lua/lsp_extensions.nvim'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/vim-vsnip'
  Plug 'hrsh7th/cmp-vsnip'
  Plug 'ray-x/lsp_signature.nvim'
  Plug 'nvim-treesitter/nvim-treesitter'
  Plug 'simrat39/rust-tools.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'saecki/crates.nvim', { 'tag': 'v0.1.0' }
  Plug 'ggandor/lightspeed.nvim'
  Plug 'tpope/vim-fugitive'
  Plug 'lewis6991/gitsigns.nvim'
  Plug 'onsails/lspkind-nvim'
  Plug 'SmiteshP/nvim-gps'
  Plug 'nvim-lualine/lualine.nvim'
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'arkav/lualine-lsp-progress'
  Plug 'beauwilliams/focus.nvim'

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
nnoremap <leader>t :retab<CR>
nnoremap <leader>v :Vista!!<CR>

" get the syntax flags under the cursor
nmap <leader>sp :call <SID>SynStack()<CR>
function! <SID>SynStack()
    if !exists("*synstack")
        return
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" markdown preview mappings
nmap <leader>mp <Plug>MarkdownPreviewToggle

" LSP
lua <<EOF
  -- Setup nvim-cmp.
  local cmp = require'cmp'
  local lspconfig = require'lspconfig'
  local lspkind = require'lspkind'

  local has_words_before = function()
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
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    formatting = {
      format = lspkind.cmp_format {
        with_text = false,
        maxwidth = 50,
        before = function (entry, vim_item)
          return vim_item
        end
      }
    },
    mapping = {
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif vim.fn["vsnip#available"](1) == 1 then
          feedkey("<Plug>(vsnip-expand-or-jump)", "")
        elseif has_words_before() then
          cmp.complete()
        else
          fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
        end
      end, { "i", "s" }),

      ["<c-Tab>"] = cmp.mapping(function()
        if cmp.visible() then
          cmp.select_prev_item()
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
    experimental = {
      ghost_text = true,
    }
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    if client.resolved_capabilities.document_highlight then
      vim.cmd [[
        augroup lsp_document_highlight
          autocmd! * <buffer>
          autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
          autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        augroup END
      ]]
    end

    -- Mappings.
    local opts = { noremap=true, silent=true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', '<leader>lD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', '<leader>ld', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', '<leader>lh', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', '<leader>li', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<leader>ls', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<leader>lt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<leader>ln', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<leader>la', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', '<leader>lr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<leader>ll', '<cmd>lua vim.diagnostic.show()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<leader>lL', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
    buf_set_keymap("n", "<leader>lf", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

    -- Get signatures (and _only_ signatures) when in argument lists.
    require "lsp_signature".on_attach({
      doc_lines = 0,
      handler_opts = {
        border = "none"
      },
    })
  end

  -- Setup lspconfig.
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

  -- rust-tools (calls lspconfig.rust_analyzer.setup)
  require'rust-tools'.setup {
    hover_with_actions = false,
    server = {
      on_attach = on_attach,
      flags = {
        debounce_text_changes = 150,
      },
      settings = {
        ["rust-analyzer"] = {
          cargo = {
            allFeatures = true,
          },
          completion = {
  	        postfix = {
  	          enable = false,
  	        },
          },
        },
      },
      capabilities = capabilities,
    },
  }

  lspconfig.pyright.setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }

  lspconfig.clangd.setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }

  lspconfig.clojure_lsp.setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }

  lspconfig.omnisharp.setup {
    cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(pid) },
    on_attach = on_attach,
    capabilities = capabilities,
  }

  require'nvim-treesitter.configs'.setup {
    -- One of "all", "maintained" (parsers with maintainers), or a list of languages
    ensure_installed = "maintained",

    -- Install languages synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- List of parsers to ignore installing
    ignore_install = { "javascript", "pascal" },

    highlight = {
      -- `false` will disable the whole extension
      enable = true,

      -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
      -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
      -- Using this option may slow down your editor, and you may see some duplicate highlights.
      -- Instead of true it can also be a list of languages
      additional_vim_regex_highlighting = false,
    },
  }

  require'crates'.setup {}

  -- diagnostic signs
  local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
  for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end

  -- git signs
  require'gitsigns'.setup {
    signs = {
      add          = {hl = 'GitSignsAdd'   , text = '+', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
      change       = {hl = 'GitSignsChange', text = '|', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
      delete       = {hl = 'GitSignsDelete', text = '-', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
      topdelete    = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
      changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
    },
    signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
    numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
    linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
    keymaps = {
      -- Default keymap options
      noremap = true,

      ['n ]h'] = { expr = true, "&diff ? ']h' : '<cmd>Gitsigns next_hunk<CR>'"},
      ['n [h'] = { expr = true, "&diff ? '[h' : '<cmd>Gitsigns prev_hunk<CR>'"},

      ['n <leader>hs'] = '<cmd>Gitsigns stage_hunk<CR>',
      ['v <leader>hs'] = ':Gitsigns stage_hunk<CR>',
      ['n <leader>hr'] = '<cmd>Gitsigns undo_stage_hunk<CR>',
      ['n <leader>hu'] = '<cmd>Gitsigns reset_hunk<CR>',
      ['v <leader>hu'] = ':Gitsigns reset_hunk<CR>',
      -- ['n <leader>hR'] = '<cmd>Gitsigns reset_buffer<CR>',
      ['n <leader>hp'] = '<cmd>Gitsigns preview_hunk<CR>',
      ['n <leader>hb'] = '<cmd>lua require"gitsigns".blame_line{full=true}<CR>',
      -- ['n <leader>hS'] = '<cmd>Gitsigns stage_buffer<CR>',
      -- ['n <leader>hU'] = '<cmd>Gitsigns reset_buffer_index<CR>',

      -- Text objects
      -- ['o ih'] = ':<C-U>Gitsigns select_hunk<CR>',
      -- ['x ih'] = ':<C-U>Gitsigns select_hunk<CR>'
    },
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
    current_line_blame_formatter_opts = {
      relative_time = false
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
    yadm = {
      enable = false
    },
  }

  local gps = require'nvim-gps'
  gps.setup {}

  require'lualine'.setup {
    options = {
      icons_enabled = true,
      theme = 'jellybeans',
      component_separators = { left = '', right = ''},
      section_separators = { left = '', right = ''},
      disabled_filetypes = {},
      always_divide_middle = true,
    },
    sections = {
      lualine_a = {'mode'},
      lualine_b = {'filename', 'diff', 'diagnostics'},
      lualine_c = {
        { gps.get_location, cond = gps.is_available },
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

  require'focus'.setup {
    cursorline = false,
    signcolumn = false,
  }
EOF

" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect

" format buffer
nnoremap <F1> <cmd>lua vim.lsp.buf.formatting()<CR>
" remove highlights
nnoremap <F2> :noh<CR>
" remove trailing whitespace
nnoremap <F3> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>
" adjust view
nnoremap <F4> zt5<C-y>

" navigation:

" gitgutter
nmap ]h <Plug>(GitGutterNextHunk)
nmap [h <Plug>(GitGutterPrevHunk)

" move tab
nnoremap <F8>  :tabp<CR>
nnoremap <F9>  :tabn<CR>

" remap snippet completion
imap <expr> <C-L> vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<C-L>'
smap <expr> <C-L> vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<C-L>'
imap <expr> <C-K> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<C-K>'
smap <expr> <C-K> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<C-K>'

" sane buffers
set hidden
set splitbelow
set splitright

" speedy
set updatetime=100

" cached undo
set undodir=~/.vimdid
set undofile

" gui colors
set background=dark
set termguicolors

" show current line number and relative numbers
set number
set relativenumber

" use a sign column with space for 3 signs
set signcolumn=yes:3

" use 2 lines for commands
set cmdheight=2

" add more keywords
augroup vimrc_todo
    au!
    au Syntax * syn keyword Note NOTE containedin=.*Comment.* contained
augroup END

" custom colorscheme
colorscheme autumn256

" color column at 80
set colorcolumn=80
highlight ColorColumn guibg=#303030 ctermbg=darkgrey

" lualine shows the mode too so don't bother
set noshowmode

" copypasting
set clipboard+=unnamedplus

augroup vimtexgroup
  autocmd!
  " enable conceal
  autocmd FileType tex set conceallevel=2
augroup end

" sane tabs
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
