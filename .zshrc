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
if command -v exa &>devnull; then
    alias ll="exa --long --classify --all"
else
    alias ll="ls -al"
fi

# check for bat (installed via brew), use that to syntax-highlight man pages
if [ command -v bat &>devnull ]; then
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

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# start pyenv
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

#
# Prompt Shenanigans
#

# my default prompt:
#   rachel@Rachels-MacBook-Pro .zsh % echo $PROMPT
#   %n@%m %1~ %# 

get_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

PROMPT='%B%F{magenta}%1/%f%b 👑 '
