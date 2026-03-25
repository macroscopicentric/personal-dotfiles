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
export BEADS_DIR="/Users/rachel/coding/aligned/.beads"
export JAVA_HOME=$(/usr/libexec/java_home -v 17)

# Waterworks SP helper functions — defined here (not .zshrc) so they work in
# non-interactive shells (e.g. Claude Code's Bash tool).
_find_sp_all_in_one() {
  local dir=$PWD
  while [[ "$dir" != "/" ]]; do
    [[ "$(basename $dir)" == "sp-all-in-one" ]] && { echo "$dir"; return; }
    [[ -d "$dir/sp-all-in-one" ]] && { echo "$dir/sp-all-in-one"; return; }
    dir=$(dirname "$dir")
  done
  echo ~/coding/aligned/sp-all-in-one  # fallback
}

function docker-sp {
  (cd "$(_find_sp_all_in_one)" && docker compose build --no-cache && docker compose up --scale sp-fe=0 -d)
}
function docker-sp-local {
  (cd "$(_find_sp_all_in_one)" && docker compose build --no-cache && SPRING_M3SERVICE_BASEURL=http://host.docker.internal:8087 docker compose up --scale sp-fe=0 -d)
}
function sp-fe-dev {
  (cd "$(_find_sp_all_in_one)/sp-fe" && ng serve --configuration=local)
}
function sp-fe-local {
  (cd "$(_find_sp_all_in_one)/sp-fe" && ng serve --configuration=compose)
}