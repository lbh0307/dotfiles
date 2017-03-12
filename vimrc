set nocompatible              " be iMproved, required
filetype off                  " required

" Manual vim-plug installation
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
"     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

call plug#begin()

" UI
Plug 'yous/vim-open-color'
Plug 'w0ng/vim-hybrid'
Plug 'vim-airline/vim-airline'

" Languages
Plug 'scrooloose/syntastic'
Plug 'davidhalter/jedi-vim'
Plug 'petRUShka/vim-sage'
Plug 'lervag/vimtex', { 'for': ['bib', 'tex'] }

" Util
Plug 'ervandew/supertab'
Plug 'scrooloose/nerdtree'
Plug 'airblade/vim-gitgutter'

" snippet
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'garbas/vim-snipmate'
Plug 'honza/vim-snippets'

call plug#end()

" syntatic
let g:syntastic_ignore_extensions = '\c\v^([gx]?z|lzma|bz2|sage)$'
let g:syntastic_check_on_wq = 0
let g:syntastic_quiet_messages = { "level": "warnings" }

" jedi-vim
autocmd FileType python setlocal completeopt-=preview
let g:jedi#show_call_signatures = "0"

" Nerd-tree
autocmd VimEnter * NERDTree | wincmd p
autocmd WinEnter * call s:CloseIfOnlyNerdTreeLeft()
" Close all open buffers on entering a window if the only
" buffer that's left is the NERDTree buffer
function! s:CloseIfOnlyNerdTreeLeft()
  if exists("t:NERDTreeBufName")
    if bufwinnr(t:NERDTreeBufName) != -1
      if winnr("$") == 1
        q
      endif
    endif
  endif
endfunction

" ctrlp
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

syntax on
set number
set background=dark
set backspace=2
set tabstop=4
set softtabstop=4
set shiftwidth=4
set scrolloff=4
set noexpandtab
set smartindent
set nowrap
set undolevels=1000
set laststatus=2
set mouse=a
" Briefly jump to the matching one when a bracket is inserted
set showmatch

" set for tex
if has("autocmd")
  au BufReadPost .tex set filetype=tex
  au filetype tex set shiftwidth=2
  au filetype tex set tabstop=2
  au filetype tex set softtabstop=2
  au filetype tex set grepprg=grep\ -nH\ $*
  au filetype tex set ai
endif

colorscheme hybrid

" Highlight trailing whitespace
highlight ExtraWhitespace ctermbg=darkgreen guibg=lightgreen
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
if version >= 702
	autocmd BufWinLeave * call clearmatches()
endif

autocmd FileType c,cpp,java,python,sage setlocal expandtab
autocmd FileType html,php,js,css setlocal tabstop=2 softtabstop=2 shiftwidth=2
set display+=uhex
if has('extra_search')
	set hlsearch
endif

" Exit Paste mode when leaving Insert mode
autocmd InsertLeave * set nopaste

" Move between splitted windows
nnoremap <tab> <C-W>w

" To remove highlights
nnoremap <C-l> :nohlsearch<CR>

" Center display after searching
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

if &term =~ "screen"
  " 256 colors
  let &t_Co = 256
  " restore screen after quitting
  let &t_ti = "\<Esc>7\<Esc>[r\<Esc>[?47h"
  let &t_te = "\<Esc>[?47l\<Esc>8"
  if has("terminfo")
    let &t_Sf = "\<Esc>[3%p1%dm"
    let &t_Sb = "\<Esc>[4%p1%dm"
  else
    let &t_Sf = "\<Esc>[3%dm"
    let &t_Sb = "\<Esc>[4%dm"
  endif
endif

augroup vimrc
  " C, C++ compile
  autocmd FileType c,cpp map <F5> :w<CR>:make %<CR>
  autocmd FileType c,cpp imap <F5> <Esc>:w<CR>:make %<CR>
  autocmd FileType c
        \ if !filereadable('Makefile') && !filereadable('makefile') |
        \   setlocal makeprg=gcc\ -o\ %< |
        \ endif
  autocmd FileType cpp
        \ if !filereadable('Makefile') && !filereadable('makefile') |
        \   setlocal makeprg=g++\ -o\ %< |
        \ endif

  " Python
  autocmd FileType python map <F5> :w<CR>:!python %<CR>
  autocmd FileType python imap <F5> <Esc>:w<CR>:!python %<CR>

  " Tex
  autocmd FileType tex map <F5> :w<CR>:make <CR>
augroup END
