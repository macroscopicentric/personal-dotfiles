#
# Note: I'm now on zsh on my personal machine so this is not a living config
# file. It did work the last time I used it, but no promises.
#

alias python=python3

PATH=/usr/local/bin:$PATH
PATH=/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH
PATH=/usr/local/heroku/bin:$PATH

if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

PS1='\[\033[36m\]\W \[\033[00m\]👑  '

export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

alias ll="ls -la"
alias ltree="ls -R | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/ /' -e 's/-/|/'"

alias gst="git status"
alias gd="git diff"

alias be="bundle exec"

# export PYTHONSTARTUP=~/prompt.py
export EDITOR=subl
export NVM_DIR="/Volumes/UsersHD/rachel/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

# start pyenv
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
