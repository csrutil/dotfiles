export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# ohmyzsh
export DISABLE_UPDATE_PROMPT=true
export DISABLE_AUTO_UPDATE=true

# cocoapods
export COCOAPODS_DISABLE_STATS=true

# npm
export NO_UPDATE_NOTIFIER=true

# spring
export DISABLE_SPRING=true

# homebrew
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_ANALYTICS_THIS_RUN=1
export HOMEBREW_NO_ANALYTICS_MESSAGE_OUTPUT=1

autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
RPROMPT=\$vcs_info_msg_0_
# PROMPT=\$vcs_info_msg_0_'%# '
zstyle ':vcs_info:git:*' formats '%b'

autoload -Uz compinit && compinit
setopt complete_in_word
setopt auto_menu
setopt autocd
setopt correctall
unsetopt correct_all

# https://stackoverflow.com/questions/13424429/can-zsh-do-smartcase-completion-like-vims-search
zstyle ':completion:*'  matcher-list 'm:{a-z}={A-Z}'
ZLE_REMOVE_SUFFIX_CHARS=$' \t\n;&'

# PS1="%{$fg[red]%}%n%{$reset_color%}@%{$fg[blue]%}%m %{$fg[yellow]%}%~ %{$reset_color%}%% "
autoload -U colors && colors
# PROMPT="%{$fg[red]%}%n@%M %{$fg[yellow]%}%~ %{$reset_color%}"
PROMPT="%{$fg[red]%}%n@%M %{$fg[yellow]%}%~ %{$reset_color%}"

## History file configuration
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
[ "$HISTSIZE" -lt 50000 ] && HISTSIZE=50000
[ "$SAVEHIST" -lt 10000 ] && SAVEHIST=10000

## History command configuration
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt share_history          # share command history data

ps1_anonymous(){
  export PROMPT="%{$fg[red]%}%M %{$fg[yellow]%}%~ %{$reset_color%}"
}

# https://gist.github.com/phette23/5270658
DISABLE_AUTO_TITLE="true"

precmd() {
  # sets the tab title to current dir
  echo -ne "\e]1;${PWD##*/}\a"
}

set_proxy() {
  export HTTP_PROXY="http://127.0.0.1:7890"
  export HTTPS_PROXY="http://127.0.0.1:7890"
  export ALL_PROXY="http://127.0.0.1:7890"
  # export HTTP_PROXY="socks5://127.0.0.1:7891"
  # export HTTPS_PROXY="socks5://127.0.0.1:7891"
  # export ALL_PROXY="socks5://127.0.0.1:7891"
}

unset_proxy() {
  unset HTTP_PROXY
  unset HTTPS_PROXY
  unset ALL_PROXY
}

# https://github.com/rclone/rclone/releases/download/v1.52.3/rclone-v1.52.3-osx-amd64.zip
dropbox_pull() {
  /usr/local/bin/rclone copy dropbox:/ ~/Dropbox -v
}

dropbox_push() {
  /usr/local/bin/rclone sync ~/Dropbox dropbox:/ --progress
}

set_ram_disk() {
  # 2097152 * 8
  # 8GB
  diskutil erasevolume HFS+ Ram `hdiutil attach -nomount ram://8388608`
}

set_random_mac() {
  ifconfig en0 | grep ether

  # generate a new random one
  addr=$(openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//')

  # set spoofed address (substitute with generated one from above)
  sudo ifconfig en0 ether $addr

  # make sure new address returns
  ifconfig en0 | grep ether
}

remove_set_ram_disk() {
  diskutil umount /Volumes/Ram
}

install_ruby() {
  version=$1

  RUBY_BUILD_MIRROR_URL=http://localhost:9000/ruby-$version.tar.bz2 \
    RUBY_CONFIGURE_OPTS="--disable-install-doc --with-jemalloc --with-openssl-dir=$(brew --prefix libressl)" \
    rbenv install $version --verbose
}

flush_dns() {
  sudo killall -HUP mDNSResponder;
  sudo killall mDNSResponderHelper;
  sudo dscacheutil -flushcache
  sudo killall -HUP mDNSResponder
  sudo mDNSResponder
  sudo mDNSResponderHelper
}

seed() {
  # date +%s | sha256sum | base64 | head -c 32 ; echo
  # seed=$(date | shasum | base64 | head -c $1 ; echo)
  seed=$(openssl rand -base64 $1)
  echo $seed | pbcopy
  echo $seed
}

clean_efi() {
  sudo rm -rf .Spotlight-V100 .Trashes .fseventsd
  sudo find . -name '._*' -exec rm -rf {} \;
}

set_new_mac() {
  sudo ifconfig en0 ether $(openssl rand -hex 6 | sed 's%\(..\)%\1:%g; s%.$%%')
}

# ALIAS
alias axel="axel --alternate --insecure -n 10"

alias cnpm="npm --registry=https://registry.npm.taobao.org \
--cache=$HOME/.npm/.cache/cnpm \
--disturl=https://npm.taobao.org/dist \
--userconfig=$HOME/.cnpmrc"

alias rsync="rsync -ah --progress"

# https://github.com/BurntSushi/ripgrep
alias rg="rg -j $(sysctl -n hw.ncpu) -p"

# ALIAS


# rbenv
if [ -d $HOME/.rbenv ] ; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
fi

# phpenv
if [ -d $HOME/.phpenv ] ; then
  export PATH="$HOME/.phpenv/bin:$PATH"
  eval "$(phpenv init -)"
fi

# nvm
if [ -d $HOME/.nvm ] ; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm
  [[ -r $NVM_DIR/bash_completion ]] && . $NVM_DIR/bash_completion
fi

# pyenv
if [ -d $HOME/.pyenv ] ; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
fi

# Postgres
PG_HOME=/Applications/Postgres.app/Contents/Versions/latest
if [ -d $PG_HOME ] ; then
  export PATH="$PG_HOME/bin:$PATH"
  export DYLD_FALLBACK_LIBRARY_PATH=$PG_HOME/lib
fi

# mysql
MYSQL_HOME=/usr/local/mysql
if [ -d $MYSQL_HOME ] ; then
  export PATH="$MYSQL_HOME/bin:$MYSQL_HOME/support-files:$PATH"
  export DYLD_FALLBACK_LIBRARY_PATH="$MYSQL_HOME/lib:$DYLD_FALLBACK_LIBRARY_PATH"
fi

# gvm
[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"

# ssh
[[ -s "$HOME/.ssh-agent" ]] && source $HOME/.ssh-agent
if [ -z "$SSH_AUTH_SOCK" ] ; then
  ssh-agent | sed 's/^echo/#echo/' > $HOME/.ssh-agent
  source $HOME/.ssh-agent
fi

# lunchy
# LUNCHY_DIR=$(dirname `gem which lunchy`)/../extras
# if [ -f $LUNCHY_DIR/lunchy-completion.zsh ]; then
#   . $LUNCHY_DIR/lunchy-completion.zsh
# fi

# platform-tools
if [ -d /usr/local/platform-tools ] ; then
  export PATH=$PATH:/usr/local/platform-tools
fi

# JAVA
if [ -d $HOME/.java ] ; then
  JAVA_VER=jdk-13.0.1.jdk
  export JAVA_HOME=$HOME/.java/$JAVA_VER/Contents/Home
  export PATH=$PATH:$JAVA_HOME/bin
fi

# Wireshark
if [ -d /Applications/Wireshark.app/Contents/MacOS ] ; then
  export PATH=$PATH:/Applications/Wireshark.app/Contents/MacOS/
fi

# https://github.com/rubyjs/libv8/issues/282#issuecomment-570285528
# export CXX=clang++
# export GYPFLAGS=-Dmac_deployment_target=10.15

# RUBY_BUILD_MIRROR_URL=http://localhost:9000/ruby-2.7.2.tar.bz2 \
#   RUBY_CONFIGURE_OPTS="--disable-install-doc --with-jemalloc --with-openssl-dir=$(brew --prefix libressl)" \
#   rbenv install 2.7.2 --verbose

# export PATH=$PATH:~/Documents/go/bin
export EDITOR="emacs -nw"
