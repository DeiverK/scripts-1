syntax on
colo desert


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


"au BufNewFile,BufRead *.py match BadWhitespace /\s\+$/


abbr _sh #!/bin/bash
abbr _py #!/usr/bin/env python36
abbr _pr print("")

nmap <C-N> :set invnumber<CR>

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

set splitbelow
set splitright
