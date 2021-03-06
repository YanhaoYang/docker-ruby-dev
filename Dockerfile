FROM ruby:2.6.3
MAINTAINER Yanhao Yang <yanhao.yang@gmail.com>

# Update system and install main dependencies
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
	echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list && \
	apt-get update -y && \
	apt-get install -y --no-install-recommends wget unzip &&\
	apt-get install -y google-chrome-stable

# Chromedriver Environment variables
ENV CHROMEDRIVER_DIR /usr/bin

# Download and install Chromedriver
RUN chrome_version=$(google-chrome-stable --version | awk -F'[ \.]' '{ print $3 }') && \
  chromedriver_version=$(curl http://chromedriver.storage.googleapis.com/LATEST_RELEASE_${chrome_version}) && \
  echo $chromedriver_version && \
  wget -q --continue -P $CHROMEDRIVER_DIR "http://chromedriver.storage.googleapis.com/${chromedriver_version}/chromedriver_linux64.zip" && \
	unzip $CHROMEDRIVER_DIR/chromedriver* -d $CHROMEDRIVER_DIR && \
	rm $CHROMEDRIVER_DIR/chromedriver*.zip

# Development tools
RUN \
  apt-get update && \
  apt-get install -y apt-transport-https && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
  # for build vim
  python-dev libncurses5-dev libncursesw5-dev \
  python3-dev ruby-dev lua5.1 liblua5.1-dev \
  zsh silversearcher-ag locales sudo less \
  && \
  apt-get autoremove -y && \
  apt-get autoclean && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY files/gs /usr/local/bin/gs
COPY files/dummy_server /usr/local/bin/dummy_server

RUN \
  chsh --shell /bin/zsh && \
  echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
  locale-gen && \
  groupadd --gid 1000 docker && \
  useradd --gid 1000 --uid 1000 --create-home docker && \
  echo "docker ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/user && \
  chmod 0440 /etc/sudoers.d/user && \
  # build vim
  cd /tmp && \
  git clone https://github.com/vim/vim.git && \
  cd /tmp/vim && \
  ./configure \
    --with-features=huge \
    --enable-multibyte \
    --enable-rubyinterp=yes \
    --enable-pythoninterp=yes \
    --with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu \
    --enable-python3interp=yes \
    --with-python3-config-dir=/usr/lib/python3.4/config-3.4m-x86_64-linux-gnu \
    --enable-luainterp=yes \
    --enable-cscope \
  && \
  make && \
  make install && \
  cd ~ && \
  rm -rf /tmp/*

ENV TERM=xterm-256color

# To make oh-my-zsh installer happy
ENV SHELL=/usr/bin/zsh

USER docker

COPY vim /home/docker/.vim

RUN \
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" && \
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && \
  git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
  sudo chown --recursive docker:docker ~/.vim && cd ~/.vim && ./setup.sh && cd ~ && \
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && \
  ~/.fzf/install --all && \
  gem install ripper-tags

COPY files/.zshrc /home/docker/.zshrc

# nvm && yarn
ENV NODE_VERSION v10.15.3
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash && \
  bash -c "\
    source $HOME/.nvm/nvm.sh && \
    nvm install $NODE_VERSION && \
    nvm use $NODE_VERSION && \
    npm install -g yarn && \
    echo 'export NVM_DIR=\"$HOME/.nvm\"' >> ~/.zshrc.local && \
    echo '[ -s \"\$NVM_DIR/nvm.sh\" ] && . \"\$NVM_DIR/nvm.sh\"' >> ~/.zshrc.local && \
    echo 'nvm use $NODE_VERSION' >> ~/.zshrc.local"

EXPOSE 3000

CMD ["/usr/local/bin/dummy_server"]
