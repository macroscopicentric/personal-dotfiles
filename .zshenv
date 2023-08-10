export PATH=/usr/local/bin:$PATH
export PATH=/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH
export PATH=/usr/local/heroku/bin:$PATH

# This one is for poetry, which doesn't recommend homebrew as a formal
# installation path and also puts itself somewhere weird.
# Poetry installation docs, for reference:
# https://python-poetry.org/docs/#installing-with-the-official-installer
export PATH="/Users/rachel/.local/bin:$PATH"

alias python=python3

export EDITOR=subl
export NVM_DIR="/Volumes/UsersHD/rachel/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm