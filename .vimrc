" Plugin Manager (vim-plug) — https://github.com/junegunn/vim-plug
" :PlugInstall to install, :PlugUpdate to update, :PlugClean to remove unused
call plug#begin()
  " Add/change/delete surrounding characters
  " cs"'  change surrounding " to '
  " ds"   delete surrounding "
  " ysiw) add () around word under cursor
  " yss)  surround the whole line with ()
  Plug 'tpope/vim-surround'

  " Toggle comments with gc
  " gcc   comment/uncomment current line
  " gc5j  comment next 5 lines
  " gcap  comment a whole paragraph
  Plug 'tpope/vim-commentary'

  " Makes . (repeat last action) work correctly with surround/commentary
  Plug 'tpope/vim-repeat'

  " Fuzzy finder — :Files, :Buffers, :Rg (grep), :GFiles (git-tracked only)
  " Requires: brew install fzf ripgrep
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
call plug#end()

" Tab Config
set shiftwidth=4 smarttab
set expandtab
set tabstop=4

" Other
syntax on
set number relativenumber    " hybrid: absolute on current line, relative offsets elsewhere
set ignorecase smartcase     " case-insensitive unless pattern contains a capital letter
set incsearch hlsearch       " jump to and highlight matches as you type
set scrolloff=8              " always keep 8 lines visible above/below cursor
set wildmenu                 " show visual tab-complete menu in command mode
set backspace=indent,eol,start  " allow backspace over indents, line breaks, and insert start
filetype plugin indent on    " enable filetype detection, filetype plugins, and smart indentation
