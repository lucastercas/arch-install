#!/bin/bash

plugins=(
  'sheerun/vim-polyglot'                         
  'morhetz/gruvbox'
  'vim-airline/vim-airline'
  'vim-airline/vim-airline-themes'
  'junegunn/fzf'
  'junegunn/fzf.vim'
  #'artur-shaik/vim-javacomplete2'
  #'preservim/nerdtree'
  #'tiagofumo/vim-nerdtree-syntax-highlight'
  #'ryanoasis/vim-devicons'
  #'tpope/vim-fugitive'
  #'SirVer/ultisnips'
  'vimwiki/vimwiki'
  'jiangmiao/auto-pairs'
  #'neoclide/coc.nvim'
  #'tpope/vim-surround'
  'dense-analysis/ale'
  #'neoclide/coc.nvim'
  'Yggdroot/indentLine'
  'mhinz/vim-startify'
  #'itchyny/lightline.vim'
  #'mattn/emmet-vim'
)
 
function vim_plugins() {
  rm -rf $HOME/.vim/pack/plugins/start
  mkdir -p $HOME/.vim/pack/plugins/start
  for plugin in "${plugins[@]}"; do
    arr=(${plugin//\// })
    echo "-> cloning to $HOME/.vim/pack/plugins/start/${arr[1]}"
    git clone --depth 1 "https://github.com/${plugin}" "$HOME/.vim/pack/plugins/start/${arr[1]}"
  done
}

function fzf() {
  git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
  $HOME/.fzf/install
}

