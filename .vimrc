set showmode
set nonumber
set nohlsearch
set autoindent
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set textwidth=79
set fileformat=unix
set encoding=utf-8


au BufNewFile,BufRead *.py match BadWhitespace /\s\+$/


abbr _sh #!/bin/bash
nmap <C-N> :set invnumber<CR>


# set number
