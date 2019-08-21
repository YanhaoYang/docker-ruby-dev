#!/bin/bash

if [[ ! -d bundle/coc.nvim ]]; then
  git clone https://github.com/neoclide/coc.nvim.git ~/.vim/bundle/coc.nvim
  cd ~/.vim/bundle/coc.nvim && yarn install && cd ~/.vim
fi

[[ -d bundle/Vundle.vim ]] || git clone https://github.com/VundleVim/Vundle.vim.git bundle/Vundle.vim
vim --not-a-term -u ./plugins +BundleInstall +qa
vim --not-a-term -c ":CocInstall coc-snippets | sleep 5000m | qa"
vim --not-a-term -c ":CocInstall coc-solargraph | sleep 5000m | qa"
