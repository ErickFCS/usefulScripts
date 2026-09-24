
alias ll='ls -l'
alias la='ls -A'
alias lla='ls -lA'
alias l='ls -CF'
alias reload='. ~/.bashrc'

setpass() {
  local pass1 pass2

  read -s -p "Enter session password: " pass1
  echo
  read -s -p "Confirm session password: " pass2
  echo

  if [[ "$pass1" != "$pass2" ]]; then
    echo "Error: Passwords do not match. Password not set." >&2
    return 1
  fi

  export password="$pass1"
  echo "Password successfully stored in \$password for this session."
}
export -f setpass

function enc() {
  local input
  if [[ -t 0 ]]; then
    input="$1"
  else
    input="$(cat)"
  fi
  printf '%s\n' "$input" | openssl enc -aes-256-cbc -pbkdf2 -a -A -pass pass:"${password:=''}" -nosalt | tr '/+' '_-'
  echo
}
export -f enc

function dec() {
  local input
  if [[ -t 0 ]]; then
    input="$1"
  else
    input="$(cat)"
  fi
  local output
  output="$(printf '%s\n' "$input" | tr '_-' '/+' | openssl enc -d -aes-256-cbc -pbkdf2 -a -A -pass pass:"${password:=''}" -nosalt 2>/dev/null)"
  if [[ $? -eq 0 ]]; then
    printf '%s\n' "$output"
  else
    echo -n "Error"
  fi
}
export -f dec

function lsdec() {
  for element in ./*; do
    local basepath="${element##*/}"
    local extension=".${basepath##*.}"
    if [[ -d "$basepath" ]]; then
      extension=""
    fi
    local name="${basepath%.*}"
    printf "%-50s <- %s\n" "$(dec "$name")$extension" "$basepath"
  done
}
export -f lsdec

function encfile() {
  local basedir="$(dirname $1)"
  local basepath="$(basename $1)"
  local extension=""
  if [[ "$basepath" == *.* && "$basepath" != .* ]]; then
    extension=".${basepath##*.}"
  fi
  local name="${basepath%.*}"
  local newname
  newname="$(enc "$name")"

  if [[ $? -eq 0 ]]; then
    mv -v "$1" "$basedir/$newname$extension"
  else
    echo -n "Error"
  fi
}
export -f encfile

function decfile() {
  local basedir="$(dirname $1)"
  local basepath="$(basename $1)"
  local extension=""
  if [[ "$basepath" == *.* && "$basepath" != .* ]]; then
    extension=".${basepath##*.}"
  fi
  local name="${basepath%.*}"
  local newname
  newname="$(dec "$name")"

  if [[ $? -eq 0 ]]; then
    mv -v "$1" "$basedir/$newname$extension"
  else
    echo -n "Error"
  fi
}
export -f decfile

if command -v wezterm &> /dev/null; then
  alias icat="wezterm imgcat"
fi

if command -v nvim &> /dev/null; then
  alias snvim="sudo -E nvim"
fi

if command -v eza &> /dev/null; then
  alias ls='eza --icons --group-directories-first'
  alias ll='eza -lh --icons --group-directories-first'
  alias la='eza -a --icons --group-directories-first'
  alias tree='eza --tree'
  alias itree='eza --tree --icons'
  alias l='eza -F'
fi

if command -v bat &> /dev/null; then
  alias cat='bat'
fi

if command -v zoxide &> /dev/null; then
  eval "$(zoxide init bash)"
  alias cd='z'
fi

if command -v rnr &>/dev/null; then
  alias rn='rnr regex'
fi
