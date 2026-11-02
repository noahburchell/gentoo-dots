export TERMINAL=footclient
export EDITOR=mg
export VISUAL=mg

export XDG_CURRENT_DESKTOP=sway
export XDG_RUNTIME_DIR=/run/user/$UID

export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XCURSOR_PATH="$XDG_DATA_HOME/icons:/usr/share/icons"

export GOPATH="$XDG_DATA_HOME/go"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export NPM_CONFIG_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/npm"
export PYTHON_HISTORY="$XDG_DATA_HOME/python/history"
export NO_AT_BRIDGE=1
export GTK_A11Y=none
export STEAM_RUNTIME_LOGGER=0

typeset -gU path
path=(~/Scripts ~/.local/bin "$CARGO_HOME/bin" "$GOPATH/bin" $path)
