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

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

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

# grab current branch and display in prompt
# source: https://git-scm.com/book/en/v2/Appendix-A%3A-Git-in-Other-Environments-Git-in-Zsh
autoload -Uz vcs_info add-zsh-hook
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst

# These lines are specifically for staged + unstaged changes
# source: https://salferrarello.com/zsh-git-status-prompt/
add-zsh-hook precmd vcs_info
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr ' *'
zstyle ':vcs_info:*' stagedstr ' +'

zstyle ':vcs_info:git:*' formats '(%b%u%c)'

PROMPT='%B%F{magenta}%1/%f%b ${vcs_info_msg_0_} 👑 '
