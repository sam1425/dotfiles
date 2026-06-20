
emscripten() {
    export EMSDK_QUIET=1
    export PATH=$PATH:$HOME/.scripts/usrbin/
    source "$HOME/Documents/Programming/wasm/emsdk/emsdk_env.sh"
}

#homebrew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
#homebrew

#conda
[ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh
#end conda

#bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
#end bun

#cargo
. "$HOME/.cargo/env"
#end cargo

## fnm manager for versining (node.js)
#FNM_PATH="$HOME/.local/share/fnm"
#if [ -d "$FNM_PATH" ]; then
#  export PATH="$HOME/.local/share/fnm:$PATH"
#  eval "`fnm env`"
#fi

#eval "$(fnm env --use-on-cd)" 

#ruby:
export GEM_HOME="$(ruby -e 'puts Gem.user_dir')"
export PATH="$PATH:$GEM_HOME/bin"

# tmux auto-start
[ -f "$HOME/.config/zsh/program-specific/tmux.zsh" ] && source "$HOME/.config/zsh/program-specific/tmux.zsh"

#sdkman
#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
