msg="This is a very long text that we want to wrap properly without using ten different echo commands because that would be inefficient."

{ fold -s -w 40 <<< "$msg"; cat << 'EOF'

  ^__^
  (oo)\_______
   (__)\       )\/\
       ||----w |
       ||     ||
EOF
} | boxes -d stone -p a1
