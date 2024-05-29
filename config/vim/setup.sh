#!/bin/bash

sudo gem install solargraph

if [[ ! -d bundle/coc.nvim ]]; then
  mkdir -p $HOME/.config/coc
  git clone https://github.com/neoclide/coc.nvim.git bundle/coc.nvim
  cd bundle/coc.nvim && npm ci
  mkdir -p $HOME/.config/coc/extensions && \
    cd $HOME/.config/coc/extensions && \
    yarn add coc-snippets && \
    yarn add coc-solargraph
  cd ~/.vim
fi

[[ -d bundle/Vundle.vim ]] || git clone https://github.com/VundleVim/Vundle.vim.git bundle/Vundle.vim
vim --not-a-term -u ./plugins +BundleInstall +qa
