# nvm && yarn
export NODE_VERSION=v10.16.0
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash && \
  bash -c "\
    source $HOME/.nvm/nvm.sh && \
    nvm install $NODE_VERSION && \
    nvm use $NODE_VERSION && \
    npm install -g yarn && \
    echo 'export NVM_DIR=\"$HOME/.nvm\"' >> ~/.zshrc.local && \
    echo '[ -s \"\$NVM_DIR/nvm.sh\" ] && . \"\$NVM_DIR/nvm.sh\"' >> ~/.zshrc.local && \
    echo 'nvm use $NODE_VERSION' >> ~/.zshrc.local"

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" && \
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && \
  git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && \
  ~/.fzf/install --all && \
  gem install ripper-tags

cp config/zshrc ~/.zshrc
cp config/irbrc ~/.irbrc
cp config/vim ~/.vim

bash -c "\
  source $HOME/.nvm/nvm.sh && \
  cd ~/.vim && ./setup.sh"
