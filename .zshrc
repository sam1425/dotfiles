# ░▀▀█░█▀▀░█░█░█▀▄░█▀▀
# ░▄▀░░▀▀█░█▀█░█▀▄░█░░
# ░▀▀▀░▀▀▀░▀░▀░▀░▀░▀▀▀
# sam's edit from rxyhn's Z-Shell configuration
# https://www.reddit.com/r/unixporn/comments/uxpydc/awesome_rxyhns_workflow/
# https://github.com/raexera/yoru/tree/main/misc/home

#used for testing fastness:
#zmodload zsh/zprof

while read file
do 
  source "/home/$USER/.config/zsh/$file.zsh"
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

#zprof
