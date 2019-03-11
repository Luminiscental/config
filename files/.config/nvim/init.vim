set nocompatible

let g:hybrid_termcolors=256
let g:hybrid_termtrans=1

let $RUST_SRC_PATH = systemlist("rustc --print sysroot")[0] . "/lib/rustlib/src/rust/src"

let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_enter = 1
let g:ale_virtualtext_cursor = 1
let g:ale_rust_rls_config = {
	\ 'rust': {
		\ 'all_targets': 1,
		\ 'build_on_save': 1,
		\ 'clippy_preference': 'on'
	\ }
	\ }
let g:ale_rust_rls_toolchain = ''
let g:ale_linters = {'rust': ['rls']}
let g:ale_sign_error = "✖"
let g:ale_sign_warning = "⚠"
let g:ale_sign_info = "i"
let g:ale_sign_hint = "➤"

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

" Use a locally modified version of the deus colorscheme for lightline
" (i.e. I edited the deus.vim file in the autoload part of the lightline folder)
let g:lightline = {
      \ 'colorscheme': 'deus',
      \ }

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
    " Build on install with support for everything using the system clang
    call dein#add('Valloric/YouCompleteMe', {'build': './install.sh --all --system-libclang'})
    " Not merged because of manual building
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
    call dein#add('justinmk/vim-sneak')
    " Not merged because of modified autoload file
    call dein#add('itchyny/lightline.vim', {'merged': 0})
    call dein#add('machakann/vim-highlightedyank')
    "call dein#add('andymass/vim-matchup')
    call dein#add('w0rp/ale')
    call dein#add('cespare/vim-toml')
    call dein#add('rust-lang/rust.vim')
    call dein#add('plasticboy/vim-markdown')

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

noremap <F1> :YcmCompleter FixIt<CR>
noremap <F2> :noh<CR>
nnoremap <F3> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>
noremap <F8>  :tabp<CR>
noremap <F9>  :tabn<CR>

set hidden
set splitbelow
set splitright
set updatetime=100

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

highlight ColorColumn guibg=#1e272b ctermbg=darkgreen
set colorcolumn=100
set noshowmode
set guicursor=

set tabstop=4
set shiftwidth=4
set expandtab
