
" coc extensions
let g:coc_global_extensions = [ 'coc-pairs', 'coc-snippets', 'coc-java', 'coc-rls', 'coc-vimtex', 'coc-python', 'coc-json', 'coc-tsserver' ]

" colors, idk if necessary
let g:hybrid_termcolors=256
let g:hybrid_termtrans=1

" ALE linting

" Stuff that goes here doesn't integrate with coc, so things like [c ]c \cf
" e.t.c. don't work
"let g:ale_linters = {'clojure': ['clj-kondo']}

" better python syntax
let g:python_highlight_all = 1

" horrendous ) overrides in insert mode begone
let g:sexp_enable_insert_mode_mappings = 0

" better java syntax
let g:java_highlight_functions = 1
let g:java_highlight_java_lang_ids = 1

" markdown preview config
let g:mkdp_browser = 'firefox'

" lightline config
let g:lightline = {
      \ 'colorscheme': 'jellybeans',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'cocstatus', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'cocstatus': 'coc#status'
      \ },
      \ }

let g:vimtex_compiler_progname = 'nvr'


" tex pdf previews
let g:vimtex_view_method='mupdf'

" latex formatting
let g:vimtex_format_enabled=1

" log cxx highlighting stuff
let g:lsp_cxx_hl_log_file = '/tmp/vim-lsp-cxx-hl.log'
let g:lsp_cxx_hl_verbose_log = 1

" add the dein installation directory into runtimepath
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

if dein#load_state('~/.cache/dein')
    call dein#begin('~/.cache/dein')

    call dein#add('~/.cache/dein/repos/github.com/Shougo/dein.vim')
    call dein#add('rodnaph/vim-color-schemes')
    call dein#add('ctrlpvim/ctrlp.vim')
    call dein#add('vim-python/python-syntax')
    call dein#add('tpope/vim-surround')
    call dein#add('scrooloose/nerdtree')
    call dein#add('airblade/vim-gitgutter')
    call dein#add('itchyny/lightline.vim')
    call dein#add('machakann/vim-highlightedyank')
    call dein#add('cespare/vim-toml')
    call dein#add('rust-lang/rust.vim')
    call dein#add('plasticboy/vim-markdown')
    call dein#add('iamcco/markdown-preview.nvim', {'on_ft': ['markdown', 'pandoc.markdown', 'rmd'],
					\ 'build': 'cd app & yarn install' })
    call dein#add('neoclide/coc.nvim', {'merge': 0, 'rev': 'release'})
    call dein#add('neovimhaskell/haskell-vim')
    call dein#add('lervag/vimtex')
    call dein#add('cohama/lexima.vim')
    call dein#add('tikhomirov/vim-glsl')
    call dein#add('honza/vim-snippets')
    call dein#add('tpope/vim-repeat')
    call dein#add('kien/rainbow_parentheses.vim')
    call dein#add('guns/vim-sexp')
    call dein#add('tpope/vim-sexp-mappings-for-regular-people')
    call dein#add('Shougo/vimproc.vim', {'build' : 'make'})
    call dein#add('idanarye/vim-vebugger')
    call dein#add('jackguo380/vim-lsp-cxx-highlight')
    "call dein#add('eraserhd/parinfer-rust', {'build': 'cargo build --release'})
    "call dein#add('dense-analysis/ale')
    call dein#add('pangloss/vim-javascript')

    call dein#end()
    call dein#save_state()
endif

filetype plugin indent on
syntax enable

" auto-install plugins on startup
if dein#check_install()
    call dein#install()
endif

" workflow mappings
nnoremap - dd
nnoremap ; :
vnoremap ; :
nnoremap <leader>t :retab<CR>
nnoremap <leader>f :NERDTreeToggle<CR>

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

" -- coc stuff --

" use <C-j> to go to the next snippet hole
let g:coc_snippet_next = '<C-j>'

" use <C-k> to go to the previous snippet hole
let g:coc_snippet_prev = '<C-k>'

" use tab for completion
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" use <cr> for confirm completion, `<C-g>u` means break undo chain at current position.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" remap keys for gotos
nmap <silent> <leader>cd <Plug>(coc-definition)
nmap <silent> <leader>cy <Plug>(coc-type-definition)
nmap <silent> <leader>ci <Plug>(coc-implementation)
nmap <silent> <leader>cr <Plug>(coc-references)
nmap <silent> <leader>cp <Plug>(coc-refactor)

" show documentation in preview window
nnoremap <silent> <leader>co :call <SID>show_documentation()<CR>

" (not) also on cursor hold
"autocmd CursorHold * silent call CocActionAsync('doHover')

function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

augroup cocgroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType haskell,c,cpp,python,rust setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" remap for rename current word
nmap <leader>cn <Plug>(coc-rename)

" format binding
xmap <leader>cs <Plug>(coc-format-selected)
nmap <leader>cs <Plug>(coc-format-selected)

" autofix binding
nmap <leader>cf <Plug>(coc-fix-current)
" codeaction binding
nmap <leader>ca <Plug>(coc-codeaction)

" show all diagnostics
nnoremap <silent> <leader>cld  :<C-u>CocList diagnostics<cr>
" manage extensions
nnoremap <silent> <leader>cle  :<C-u>CocList extensions<cr>
" show commands
nnoremap <silent> <leader>clc  :<C-u>CocList commands<cr>

" format buffer
nnoremap <F1> :call CocAction('format')<CR>
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

" coc
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" move tab
nnoremap <F8>  :tabp<CR>
nnoremap <F9>  :tabn<CR>

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

" custom colorscheme
colorscheme autumn256

" highlights / errors
highlight CocHighlightText guibg=#685742 ctermbg=brown
highlight ALEError guibg=#8b4147 ctermbg=red
highlight ALEErrorSign guifg=#8b4147 ctermfg=red
highlight link CocErrorHighlight ALEError
highlight link CocErrorSign ALEErrorSign
let g:ale_sign_error = '!!'
highlight ALEWarning guibg=#755b24 ctermbg=yellow
highlight ALEWarningSign guifg=#755b24 ctermfg=yellow
highlight link CocWarningHighlight ALEWarning
highlight link CocWarningSign ALEWarningSign
let g:ale_sign_warning = '##'
highlight ALEInfo guibg=#78824b ctermbg=green
highlight ALEInfoSign guifg=#78824b ctermfg=green
highlight link CocInfoHighlight ALEInfo
highlight link CocInfoSign ALEInfoSign
highlight CocHintSign guifg=#bad46b ctermfg=green
let g:ale_sign_info = '>>'
highlight link ALEStyleError ALEWarning
highlight link ALEStyleErrorSign ALEWarningSign
let g:ale_sign_style_error = '..'
highlight link ALEStyleWarning ALEWarning
highlight link ALEStyleWarningSign ALEWarningSign
let g:ale_sign_style_warning = '..'

" color column at 100
set colorcolumn=100
" match color of lightline
highlight ColorColumn guibg=#303030 ctermbg=darkgrey

" lightline shows the mode too so don't bother
set noshowmode

" copypasting
set clipboard+=unnamedplus

" sane tabs
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
