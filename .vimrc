set nocompatible

set noerrorbells
set visualbell

syntax on
set background=dark
colorscheme wildcharm

set scrolloff=5

filetype plugin indent on
set autoindent smartindent

set showmode
set showmatch
set showcmd

set number
set relativenumber

set nobackup
set noswapfile
set autoread
set hidden

set path+=**

set wildmenu
set title

set hlsearch 
set incsearch

set nowrap
set showcmd
set cursorline

augroup betterCursor
        autocmd!
        autocmd InsertLeave,WinEnter * set cursorline
        autocmd InsertEnter,WinLeave * set nocursorline
    augroup END

let g:netrw_browse_split = 0
let g:netrw_banner = 0

let mapleader = " "
nnoremap <leader>pv :Ex<CR>
nnoremap gb :ls<CR>:b<Space>
nnoremap gs :browse oldfiles<CR>
nnoremap gf :find<Space>
nnoremap gn :bn<CR>
nnoremap gp :bp<CR>
nnoremap gd :bd<CR>
nnoremap gc :enew<CR> 
