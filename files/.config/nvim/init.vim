
let mapleader = '\'

" vista.vim
let g:vista_sidebar_width=50

" colors, idk if necessary
"let g:hybrid_termcolors=256
"let g:hybrid_termtrans=1

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
  Plug 'airblade/vim-gitgutter'
  Plug 'itchyny/lightline.vim'
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
  Plug 'justinmk/vim-sneak'
  Plug 'neovim/nvim-lspconfig'
  Plug 'nvim-lua/lsp_extensions.nvim'
  Plug 'hrsh7th/cmp-nvim-lsp', {'branch': 'main'}
  Plug 'hrsh7th/cmp-buffer', {'branch': 'main'}
  Plug 'hrsh7th/cmp-path', {'branch': 'main'}
  Plug 'hrsh7th/nvim-cmp', {'branch': 'main'}
  Plug 'hrsh7th/vim-vsnip'
  Plug 'hrsh7th/cmp-vsnip'
  Plug 'ray-x/lsp_signature.nvim'
  Plug 'josa42/nvim-lightline-lsp'
  Plug 'nvim-treesitter/nvim-treesitter', {'do': 'TSUpdate'}

call plug#end()

call lightline#lsp#register()

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
  lspconfig.rust_analyzer.setup {
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
  }

  lspconfig.pyright.setup {
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

  -- diagnostic signs
  local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
  for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end
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

" remap sneak
map = <Plug>Sneak_;
map # <Plug>Sneak_,

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
set t_Co=256
set background=dark
set termguicolors

" show current line number and relative numbers
set number
set relativenumber

" use the sign column
set signcolumn=yes

" use 2 lines for commands
set cmdheight=2

" add more keywords
augroup vimrc_todo
    au!
    au Syntax * syn keyword Note containedin=.*Comment.* contained NOTE
augroup END

" custom colorscheme
colorscheme autumn256

" color column at 80
set colorcolumn=80
" match color of lightline
highlight ColorColumn guibg=#303030 ctermbg=darkgrey

" lightline shows the mode too so don't bother
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
