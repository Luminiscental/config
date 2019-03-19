set nocompatible

let g:hybrid_termcolors=256
let g:hybrid_termtrans=1

let g:python_highlight_all = 1

" Use a locally modified version of the deus colorscheme for lightline
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


let g:Tex_ViewRule_pdf = 'xdg-open'
let g:Tex_DefaultTargetFormat = 'pdf'

let g:dein#install_process_timeout = 240

let g:chromatica#enable_at_startup=1
let g:chromatica#global_args = ['-isystem/usr/lib/clang/7.0.1/include']
let g:chromatica#responsive_mode=1

" Add the dein installation directory into runtimepath
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

if dein#load_state('~/.cache/dein')
    call dein#begin('~/.cache/dein')

    call dein#add('~/.cache/dein/repos/github.com/Shougo/dein.vim')
    " Not merged because of manual building
    call dein#add('arakashic/chromatica.nvim', {'merged': 0})
    call dein#add('rodnaph/vim-color-schemes')
    call dein#add('ctrlpvim/ctrlp.vim')
    call dein#add('vim-python/python-syntax')
    call dein#add('tpope/vim-surround')
    call dein#add('scrooloose/nerdtree')
    call dein#add('airblade/vim-gitgutter')
    call dein#add('vim-latex/vim-latex')
    " Not merged because of modified autoload file
    call dein#add('itchyny/lightline.vim', {'merged': 0})
    call dein#add('machakann/vim-highlightedyank')
    "call dein#add('andymass/vim-matchup')
    call dein#add('cespare/vim-toml')
    call dein#add('rust-lang/rust.vim')
    call dein#add('plasticboy/vim-markdown')
    call dein#add('neoclide/coc.nvim', {'build': 'yarn install'})
    call dein#add('neovimhaskell/haskell-vim')
    call dein#add('lervag/vimtex')

    call dein#end()
    call dein#save_state()
endif

filetype plugin indent on
syntax enable

if dein#check_install()
    call dein#install()
endif

nnoremap - dd
nnoremap <leader>t :retab<CR>
nnoremap <leader>f :NERDTreeToggle<CR>
nnoremap <leader>b $a {<CR>}<Esc>ko

nmap <leader>sp :call <SID>SynStack()<CR>
function! <SID>SynStack()
    if !exists("*synstack")
        return
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

"coc stuff
" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> for trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> for confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[c` and `]c` for navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> <leader>cd <Plug>(coc-definition)
nmap <silent> <leader>cy <Plug>(coc-type-definition)
nmap <silent> <leader>ci <Plug>(coc-implementation)
nmap <silent> <leader>cr <Plug>(coc-references)

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>cn <Plug>(coc-rename)

" Fix autofix problem of current line
nmap <leader>cf  <Plug>(coc-fix-current)

noremap <F1> :YcmCompleter FixIt<CR>
noremap <F2> :noh<CR>
nnoremap <F3> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>
noremap <F8>  :tabp<CR>
noremap <F9>  :tabn<CR>

set hidden
set splitbelow
set splitright
set updatetime=300

set undodir=~/.vimdid
set undofile

set t_Co=256
set background=dark
set termguicolors
set number                     " Show current line number
set relativenumber             " Show relative line numbers
set signcolumn=yes
" https://github.com/vim/vim/issues/1735#issuecomment-383353563
set lazyredraw
set synmaxcol=500
set laststatus=2
set cmdheight=2
set shortmess+=c

colorscheme autumn256

hi clear YcmErrorSection
hi YcmErrorSection guibg=#af545b ctermbg=red

hi clear YcmWarningSection
hi YcmWarningSection guibg=#c9a554 ctermbg=yellow

highlight link ALEWarningSign Todo
highlight link ALEErrorSign WarningMsg
highlight link ALEVirtualTextWarning Todo
highlight link ALEVirtualTextInfo Todo
highlight link ALEVirtualTextError WarningMsg

highlight ALEError guibg=#af545b ctermbg=red
highlight ALEWarning guibg=#c9a554 ctermbg=yellow

highlight CocHighlightText guibg=#685742 ctermbg=green

highlight ColorColumn guibg=#1e272b ctermbg=darkgreen
set colorcolumn=100
set noshowmode
set guicursor=

set tabstop=4
set shiftwidth=4
set expandtab
