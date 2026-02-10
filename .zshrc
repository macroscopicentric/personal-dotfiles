#
# Secrets and Local-Only Management
#

[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

#
# Aliases
#

alias ltree="ls -R | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/ /' -e 's/-/|/'"

alias gst="git status"
alias gd="git diff"

alias dup="docker compose up -d"
alias ddown="docker compose down"
alias dprune="docker system prune --all --force"

alias work="cd ~/coding/aligned"
alias docker-sp="cd ~/coding/aligned/sp-all-in-one && docker compose up --build --scale sp-fe=0"
alias docker-sp-local="cd ~/coding/aligned/sp-all-in-one && SPRING_M3SERVICE_BASEURL=http://host.docker.internal:8084 docker-sp"
alias db-sp="psql service=sp-local"

# Frontend aliases
alias sp-fe-dev="cd ~/coding/aligned/sp-all-in-one/sp-fe && ng serve --configuration=local"
alias sp-fe-local="cd ~/coding/aligned/sp-all-in-one/sp-fe && ng serve --configuration=compose"


#
# Fancy Brew-Installed Stuff
#

# check for zsh-completions
if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

    autoload -Uz compinit
    compinit
fi

# check for eza (installed via brew), gives fancier ls output
if command -v eza &>/dev/null; then
    alias ll="eza --long --all"
else
    alias ll="ls -al"
fi

# check for bat (installed via brew), use that to syntax-highlight man pages
if command -v bat &>/dev/null; then
    export BAT_THEME="ansi"
    alias cat='bat'
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

#
# Extra work to load git autocomplete for zsh (from https://www.oliverspryn.com/blog/adding-git-completion-to-zsh)
# This should also load poetry autocomplete for zsh if poetry is installed
# (see note in .zshenv for doc link, I modified the path on install from
# .zfunc to .zsh to match this pre-existing dir).
#
zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
fpath=(~/.zsh $fpath)

autoload -Uz compinit && compinit


#
# Language-Specific Stuff
#

# bitbucket
# usage: git diff | bbsnippet "snippet title" "filename"
export BITBUCKET_WORKSPACE="waterworks"
export BITBUCKET_USER="rachel@squadformers.com"
bbsnippet() {
  local title="${1:-Untitled}"
  local filename="${2:-snippet.txt}"
  curl -s -X POST \
    -u "${BITBUCKET_USER}:${BITBUCKET_TOKEN}" \
    -F "title=${title}" \
    -F "file=@-;filename=${filename}" \
    -F "is_private=true" \
    "https://api.bitbucket.org/2.0/snippets/${BITBUCKET_WORKSPACE}" \
  | jq -r '.links.html.href'
}

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# python
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# ruby
alias be="bundle exec"
if which rbenv > /dev/null; then eval "$(rbenv init - zsh)"; fi

#
# Prompt Shenanigans
# Most basic info pulled from https://scriptingosx.com/2019/07/moving-to-zsh-06-customizing-the-zsh-prompt/
#

# my default prompt:
#   rachel@Rachels-MacBook-Pro .zsh % echo $PROMPT
#   %n@%m %1~ %# 

# source the git-provided git prompt
# source: https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
source ~/.git-prompt.sh

# allow prompt substitution, show dirty state in color (incl. untracked files), define prompt
# source: same script as above
setopt prompt_subst
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWCOLORHINTS=1
GIT_PS1_SHOWUNTRACKEDFILES=1
precmd () { __git_ps1 "%B%F{magenta}%1/%f%b " "👑 " "| %s " }

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:/opt/homebrew/opt/openjdk@17/bin:$PATH"
export JAVA_HOME=$(/usr/libexec/java_home -v 17)
