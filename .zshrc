#used for testing fastness:
#zmodload zsh/zprof

while read file
do 
  source "$HOME/.config/zsh/$file.zsh"
done <<-EOF
env
aliases
utility
options
keybinds
plugins
prompt
EOF

[[ -t 0 ]] && stty -echoctl

#zprof
