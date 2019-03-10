
set nocompatible

let g:BASH_Ctrl_j = 'off'

let g:hybrid_termcolors=256
let g:hybrid_termtrans=1

let g:python_highlight_all = 1

let g:ycm_confirm_extra_conf = 0
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
let g:ycm_complete_in_comments=1
let g:ycm_collect_identifiers_from_tags_files=1
set completeopt-=preview
let g:ycm_min_num_of_chars_for_completion=1
let g:ycm_cache_omnifunc=0
let g:ycm_seed_identifiers_with_syntax=1
let g:ycm_key_invoke_completion = '<C-y>'

let g:Tex_ViewRule_pdf = 'xdg-open'
let g:Tex_DefaultTargetFormat = 'pdf'

let g:dein#install_process_timeout = 240

let g:UltiSnipsExpandTrigger="<C-s>"

let g:chromatica#enable_at_startup=1
let g:chromatica#global_args = ['-isystem/usr/lib/clang/7.0.1/include']

" Add the dein installation directory into runtimepath
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

if dein#load_state('~/.cache/dein')
    call dein#begin('~/.cache/dein')

    call dein#add('~/.cache/dein/repos/github.com/Shougo/dein.vim')
    call dein#add('Valloric/YouCompleteMe', {'build': './install.sh --all --system-libclang'})
    call dein#add('arakashic/chromatica.nvim', {'merged': 0})
    call dein#add('rodnaph/vim-color-schemes')
    call dein#add('ctrlpvim/ctrlp.vim')
    call dein#add('SirVer/ultisnips')
    call dein#add('vim-python/python-syntax')
    call dein#add('honza/vim-snippets')
    call dein#add('tpope/vim-surround')
    call dein#add('scrooloose/nerdtree')
    call dein#add('airblade/vim-gitgutter')
    call dein#add('vim-latex/vim-latex')

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

nmap <leader>sp :call <SID>SynStack()<CR>
function! <SID>SynStack()
    if !exists("*synstack")
        return
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

noremap <F1> :YcmCompleter FixIt<CR>
noremap <F2> :noh<CR>
nnoremap <F3> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>
noremap <F8>  :tabp<CR>
noremap <F9>  :tabn<CR>

set hidden
set splitbelow
set splitright
set updatetime=100

set t_Co=256
set background=dark
set termguicolors
set number                     " Show current line number
set relativenumber             " Show relative line numbers

colorscheme autumn256

highlight ColorColumn ctermbg=red
call matchadd('ColorColumn', '\%89v', 100)     
set guicursor=

set tabstop=4
set shiftwidth=4
set expandtab
