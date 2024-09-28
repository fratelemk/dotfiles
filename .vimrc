set nocompatible
set noerrorbells       " Disable audio bell
set visualbell         " Enable visual bell

syntax on              " Enable syntax highlighting
set background=dark    " Enable dark mode
colorscheme wildcharm  " Built-in colorscheme

filetype plugin indent on     " Enable filetype specific plugins

set autoindent smartindent

set showmode
set showmatch
set showcmd

set number
set relativenumber

set nobackup
set autoread
set noswapfile
set path+=**
set wildmenu
set title
set nowrap
set showcmd
set hlsearch
set incsearch
set hidden
set cursorline
augroup betterCursor
        autocmd!
        autocmd InsertLeave,WinEnter * set cursorline
        autocmd InsertEnter,WinLeave * set nocursorline
    augroup END


let mapleader = " "
nmap <leader>pv :Ex<CR>

" Netrw appearance
let g:netrw_browse_split = 0
let g:netrw_banner = 0


" Jump to buffer
nnoremap gb :ls<CR>:b<Space>

" List recently opened files and open a new buffer
nnoremap gs :browse oldfiles<CR>

" Search for files
nnoremap gf :find<Space>

" Cycle through buffers
nnoremap gn :bn<CR>
nnoremap gp :bp<CR>

" Plugins
call plug#begin()

Plug 'ap/vim-buftabline'
Plug 'sheerun/vim-polyglot'

call plug#end()
