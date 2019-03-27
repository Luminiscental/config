set nocompatible

" colors, idk if necessary
let g:hybrid_termcolors=256
let g:hybrid_termtrans=1

" better python syntax
let g:python_highlight_all = 1

" better java syntax
let g:java_highlight_functions = 1
let g:java_highlight_java_lang_ids = 1

" use a locally modified version of the deus colorscheme for lightline
" (i.e. I edited the deus.vim file in the autoload part of the lightline folder)
let g:lightline = {
      \ 'colorscheme': 'deus',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'cocstatus', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'cocstatus': 'coc#status'
      \ },
      \ }


" tex pdf previews
let g:Tex_ViewRule_pdf = 'xdg-open'
let g:Tex_DefaultTargetFormat = 'pdf'

" better syntax for c/c++ family by default
let g:chromatica#enable_at_startup=1
" fix arch clang lib lookup
let g:chromatica#global_args = ['-isystem/usr/lib/clang/7.0.1/include']
" update colors while typing
let g:chromatica#responsive_mode=1

" add the dein installation directory into runtimepath
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

if dein#load_state('~/.cache/dein')
    call dein#begin('~/.cache/dein')

    call dein#add('~/.cache/dein/repos/github.com/Shougo/dein.vim')
    " not merged because of manual building
    call dein#add('arakashic/chromatica.nvim', {'merged': 0})
    call dein#add('rodnaph/vim-color-schemes')
    call dein#add('ctrlpvim/ctrlp.vim')
    call dein#add('vim-python/python-syntax')
    call dein#add('tpope/vim-surround')
    call dein#add('scrooloose/nerdtree')
    call dein#add('airblade/vim-gitgutter')
    " not merged because of modified autoload file
    call dein#add('itchyny/lightline.vim', {'merged': 0})
    call dein#add('machakann/vim-highlightedyank')
    call dein#add('cespare/vim-toml')
    call dein#add('rust-lang/rust.vim')
    call dein#add('plasticboy/vim-markdown')
    call dein#add('neoclide/coc.nvim', {'build': 'yarn install'})
    call dein#add('neovimhaskell/haskell-vim')
    call dein#add('lervag/vimtex')
    call dein#add('cohama/lexima.vim')
    call dein#add('tikhomirov/vim-glsl')
    call dein#add('honza/vim-snippets')
    call dein#add('tpope/vim-repeat')

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

" use <c-space> for trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" use <cr> for confirm completion, `<C-g>u` means break undo chain at current position.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" remap keys for gotos
nmap <silent> <leader>cd <Plug>(coc-definition)
nmap <silent> <leader>cy <Plug>(coc-type-definition)
nmap <silent> <leader>ci <Plug>(coc-implementation)
nmap <silent> <leader>cr <Plug>(coc-references)

" show documentation in preview window
nnoremap <silent> <leader>co :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" remap for rename current word
nmap <leader>cn <Plug>(coc-rename)

" autofix binding
nmap <leader>cf  <Plug>(coc-fix-current)

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

" color stuff
set t_Co=256
set background=dark
set termguicolors
" show current line number and relative numbers
set number
set relativenumber
" use the sign column
set signcolumn=yes
" https://github.com/vim/vim/issues/1735#issuecomment-383353563
set lazyredraw
set synmaxcol=500
" better command presentation in the line
set laststatus=2
set cmdheight=2
set shortmess+=c

" custom colorscheme
colorscheme autumn256

" make coc highlight prettier
highlight CocHighlightText guibg=#685742 ctermbg=brown
highlight CocErrorHighlight guibg=#8b4147 ctermbg=red
highlight CocWarningHighlight guibg=#755b24 ctermbg=yellow

" color column at 100
set colorcolumn=100
" with a reasonable color
highlight ColorColumn guibg=#1e272b ctermbg=darkgreen

" lightline shows the mode too so don't bother
set noshowmode
" nvim cursor is ugly
set guicursor=

" sane tabs
set tabstop=4
set shiftwidth=4
set expandtab
