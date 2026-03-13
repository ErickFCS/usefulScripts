
alias ll='ls -l'
alias la='ls -A'
alias lla='ls -lA'
alias l='ls -CF'

if command -v git &> /dev/null; then
  alias log="git log --all --graph --oneline --decorate"
fi

if command -v wezterm &> /dev/null; then
  alias icat="wezterm imgcat"
fi

if command -v nvim &> /dev/null; then
  alias snvim="sudo -E nvim"
fi

# eza (The ls replacement)
if command -v eza &> /dev/null; then
  alias ls='eza --icons --group-directories-first'
  alias ll='eza -lh --icons --group-directories-first'
  alias la='eza -a --icons --group-directories-first'
  alias tree='eza --tree --icons'
  alias l=
fi

# bat (The cat replacement)
if command -v bat &> /dev/null; then
  alias cat='bat'
fi

# fd (The find replacement)
if command -v fd &> /dev/null; then
  alias find='fd'
fi

if command -v zoxide &> /dev/null; then
  # zoxide (Smart cd)
  eval "$(zoxide init bash)"
  alias cd='z'
fi

if command -v rnr &>/dev/null; then
  alias rn='rnr regex'
fi
