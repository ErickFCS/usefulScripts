
alias ll='ls -l'
alias la='ls -A'
alias lla='ls -lA'
alias l='ls -CF'
alias reload='. ~/.bashrc'

function enc() {
  echo "$1" | openssl enc -aes-256-cbc -pbkdf2 -a -A -pass pass:"${password:=''}" -nosalt | tr '/+' '_-'
  echo
}
export -f enc

function dec() {
  echo "$1" | tr '_-' '/+' | openssl enc -d -aes-256-cbc -pbkdf2 -a -A -pass pass:"${password:=''}" -nosalt 2>/dev/null
}
export -f dec

function lsdec() {
  fd -e 7z -d 1 -x \
    bash -c '
      password=$1
      echo "$(dec "$2").7z -> $3"
    ' _ "$password" {/.} {}
}
export -f lsdec

function encfile() {
  local fullname="$(basename "$1")"
  local extension=${$2:-'.7z'}
  local filename="${fullname%extension}"
  local dirpath=""
  filename="${filename%/}"
  [[ "$1" == *"/"* ]] && dirpath="$(dirname "$fullname")/"

  local encrypted_filename=$(enc "$base_stem")

  if [[ -n "$encrypted_filename" ]]; then
    mv -v "$1" "${dirpath}${encrypted_filename}.7z"
  fi
}
export -f encfile

function decfile() {
  local fullname="$(basename "$1")"
  local extension=${$2:-'.7z'}
  local filename="${fullname%extension}"
  local dirpath=""
  filename="${filename%/}"
  [[ "$1" == *"/"* ]] && dirpath="$(dirname "$fullname")/"

  local decrypted_filename=$(dec "$base_stem")

  if [[ -n "$decrypted_filename" ]]; then
    mv -v "$1" "${dirpath}${decrypted_filename}.7z"
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
