# ░▀▀█░█▀▀░█░█░█▀▄░█▀▀
# ░▄▀░░▀▀█░█▀█░█▀▄░█░░
# ░▀▀▀░▀▀▀░▀░▀░▀░▀░▀▀▀
# sam's edit from rxyhn's Z-Shell configuration
# https://www.reddit.com/r/unixporn/comments/uxpydc/awesome_rxyhns_workflow/
# https://github.com/raexera/yoru/tree/main/misc/home

while read file
do 
  source "/home/c0mplex/.config/zsh/$file.zsh"
done <<-EOF
theme
env
aliases
utility
options
keybinds
plugins
prompt
EOF

[[ -t 0 ]] && stty -echoctl


