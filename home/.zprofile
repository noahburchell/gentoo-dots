export QT_QPA_PLATFORMTHEME=qt6ct
export TERMINAL=alacritty
export EDITOR=nvim
export VISUAL=nvim
export MANPAGER='nvim +Man!'

export XDG_CURRENT_DESKTOP=sway
export XDG_RUNTIME_DIR=/run/user/$UID

export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XCURSOR_PATH="$XDG_DATA_HOME/icons:/usr/local/share/cursors/xorg-x11:/usr/local/share/cursors:/usr/local/share/icons:/usr/local/share/pixmaps:/usr/share/cursors/xorg-x11:/usr/share/cursors:/usr/share/pixmaps/xorg-x11:/usr/share/icons:/usr/share/pixmaps"

export GOPATH="$XDG_DATA_HOME/go"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export NPM_CONFIG_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/npm"
export PYTHON_HISTORY="$XDG_DATA_HOME/python/history"

typeset -gU path
path=(~/Scripts ~/.local/bin "$CARGO_HOME/bin" "$GOPATH/bin" $path)
