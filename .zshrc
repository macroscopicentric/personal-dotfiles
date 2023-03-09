#
# Aliases
#

alias gst="git status"
alias gd="git diff"

#
# Fancy Brew-Installed Stuff
#

# check for zsh-completions
if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

    autoload -Uz compinit
    compinit
fi

# check for exa (installed via brew), gives fancier ls output
if command -v exa &>/dev/null; then
    alias ll="exa --long --classify --all"
else
    alias ll="ls -al"
fi

# check for bat (installed via brew), use that to syntax-highlight man pages
if [ command -v bat &>/dev/null ]; then
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

#
# Extra work to load git autocomplete for zsh (from https://www.oliverspryn.com/blog/adding-git-completion-to-zsh)
#
zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
fpath=(~/.zsh $fpath)

autoload -Uz compinit && compinit


#
# Language-Specific Stuff
#

alias be="bundle exec"

# start rbenv
if which rbenv > /dev/null; then eval "$(rbenv init - zsh)"; fi

# start pyenv
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

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
