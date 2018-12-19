source $VIMRUNTIME/vimrc_example.vim

" Plugin settings "
let g:vimtex_view_method='mupdf'
let g:hybrid_termcolors=256
let g:hybrid_termtrans=1
let g:ycm_confirm_extra_conf = 0
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'

" Plugins "
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-sensible'
Plug 'lervag/vimtex'
Plug 'Valloric/YouCompleteMe'

call plug#end()

filetype plugin indent on 

" Workflow "
nnoremap - dd
noremap <F1> :VimtexCompile<CR>
noremap <F8> :tabp<CR>
noremap <F9> :tabn<CR>
set hidden

" Colours "
syntax on
set term=xterm
set t_Co=256
set background=dark
"colorscheme solarized
colorscheme twilight256
hi Normal ctermbg=none

" Line numbers "
set number
hi LineNr ctermfg=DarkGrey

" Encoding "
set encoding=utf-8

" Tabs "
set tabstop=4
set shiftwidth=4
set expandtab

