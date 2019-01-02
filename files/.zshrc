export ZSH=/home/docker/.oh-my-zsh

ZSH_THEME="fishy"

plugins=(git zsh-syntax-highlighting zsh-autosuggestions alias-tips)

source $ZSH/oh-my-zsh.sh

bindkey -v

export LANG=en_US.UTF-8
export EDITOR='vim'

alias bi='bundle install'
alias be='bundle exec'
alias bo='bundle open'
alias td='bin/rspec -fd'
alias tdf='bin/rspec -fd --fail-fast'
alias rs='rails s -b 0.0.0.0 -p 3000'

function tags(){
	ripper-tags --tag-file=tmp/tags --recursive --exclude=node_modules --verbose --tag-relative=..
}

gpc () {
  if [[ "$#" == 0 ]]
  then
    cmd="git push origin $(git_current_branch)"
  else
    cmd="git push $@ origin $(git_current_branch)"
  fi
  echo $cmd
  eval $cmd
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Local config
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
