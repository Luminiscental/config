
" Plugin settings "
let g:hybrid_termcolors=256
let g:hybrid_termtrans=1

let g:ycm_confirm_extra_conf = 0
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
let g:ycm_complete_in_comments=1
let g:ycm_collect_identifiers_from_tags_files=1
set completeopt-=preview
let g:ycm_min_num_of_chars_for_completion=1
let g:ycm_cache_omnifunc=0
let g:ycm_seed_identifiers_with_syntax=1

let g:Tex_ViewRule_pdf = 'xdg-open'
let g:Tex_DefaultTargetFormat = 'pdf'

let g:dein#install_process_timeout = 240
let g:deoplete#enable_at_startup = 1
let g:chromatica#enable_at_startup = 1
let g:python_highlight_all = 1

let g:UltiSnipsExpandTrigger="<c-j>"

"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=~/.vim/bundles/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('~/.vim/bundles')
    call dein#begin('~/.vim/bundles')

    " Let dein manage dein
    " Required:
    call dein#add('~/.vim/bundles/repos/github.com/Shougo/dein.vim')

    " Add or remove your plugins here like this:
    "call dein#add('Shougo/neosnippet.vim')
    "call dein#add('Shougo/neosnippet-snippets')
    call dein#add('vim-latex/vim-latex')
    call dein#add('airblade/vim-gitgutter')
    call dein#add('scrooloose/nerdtree')
    call dein#add('tpope/vim-surround')
    call dein#add('vim-python/python-syntax')
    call dein#add('ctrlpvim/ctrlp.vim')

    call dein#add('jeaye/color_coded', {'merged': 0})

    call dein#add('Valloric/YouCompleteMe', {'build': 'python3 install.py --clang-completer --java-completer --rust-completer'})
    call dein#add('rdnetto/YCM-Generator')

    call dein#add('SirVer/ultisnips')
    call dein#add('honza/vim-snippets')

    " Required:
    call dein#end()
    call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
if dein#check_install()
    call dein#install()
endif

"End dein Scripts-------------------------

" Workflow "
nnoremap - dd
nnoremap <leader>t :retab<CR>
"nnoremap <leader>h i#define val const auto<CR>#define var auto<CR><Esc>
map <leader>f :NERDTreeToggle<CR>

nmap <leader>sp :call <SID>SynStack()<CR>
function! <SID>SynStack()
    if !exists("*synstack")
        return
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

"Implement ycm autofix by pressing F1
noremap <F1> :YcmCompleter FixIt<CR>

"Remove search highlighting by pressing F4
noremap <F2> :noh<CR>

"Remove all trailing whitespace by pressing F5
nnoremap <F3> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

noremap <F8>  :tabp<CR>
noremap <F9>  :tabn<CR>

set hidden
set splitbelow
set splitright
set updatetime=100

" Colours "
syntax enable

if !has('nvim')
    set term=xterm
endif
set t_Co=256
set background=dark
set termguicolors
set number                     " Show current line number
set relativenumber             " Show relative line numbers
set matchpairs+=<:>

"colorscheme solarized
colorscheme autumn256

"Highlight in red when lines go over 79 characters
highlight ColorColumn ctermbg=red
call matchadd('ColorColumn', '\%80v', 100)     

" Encoding "
set encoding=utf-8

" Tabs "
set tabstop=4
set shiftwidth=4
set expandtab

