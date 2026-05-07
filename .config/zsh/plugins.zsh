##
## Plugins
##

source /usr/share/fzf/completion.zsh
source /usr/share/fzf/key-bindings.zsh

if [[ ! -f "$ZSH_RAM_CACHE/sheldon_source.zsh" || "$XDG_CONFIG_HOME/sheldon/plugins.toml" -nt "$ZSH_RAM_CACHE/sheldon_source.zsh" ]]; then
  sheldon source > "$ZSH_RAM_CACHE/sheldon_source.zsh"
fi
source "$ZSH_RAM_CACHE/sheldon_source.zsh"

# Initialize zoxide (placed after plugins to ensure completion works with fzf-tab)
if [[ ! -f "$ZSH_RAM_CACHE/zoxide_init.zsh" ]]; then
  zoxide init zsh --cmd cd > "$ZSH_RAM_CACHE/zoxide_init.zsh"
fi
source "$ZSH_RAM_CACHE/zoxide_init.zsh"

# vim:ft=zsh
