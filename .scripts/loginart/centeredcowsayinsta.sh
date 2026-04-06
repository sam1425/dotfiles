#!/bin/bash

msg=$(fortune | fold -s -w 40)

full_output=$(cat << EOF | boxes -d ansi -p a2 -a c
$msg

⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣤⣦⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣤⡀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⣿⣷⡄⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⣿⣿⡄⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⣿⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⣿⣿⣿⣿⣿⣇⠀⠀⠀⠀⠀⠀⣾⣿⣿⣿⣿⣿⡄⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣿⣿⣿⣿⣿⣿⣿⡄⠀⠀⠀⠀⣸⣿⣿⣿⣿⣿⣿⣷⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⣿⣿⣿⣿⣿⣿⣿⣷⠀⠀⠀⢠⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⠟⠛⠙⠛⢿⣿⣿⣿⣿⣿⡿⠛⠛⠻⣿⣿⣿⡇⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⡟⠁⠀⠀⠀⠀⠀⢿⣿⣿⣿⡿⠁⠀⠀⠀⠈⣿⣿⡇⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⡇⠀⠀⠀⣿⡟⠀⣸⣿⣿⣿⡇⠀⣿⡇⠀⠀⣹⣿⣧⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣤⡀⠀⠿⠇⣠⣿⣿⡟⢿⣷⣄⠿⠧⠀⣤⣿⣿⣿⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠤⠤⠤⠼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣾⣿⣿⣿⣿⠗⠒⠒⠒⠒
⠀⠀⠀⠀⠀⣀⣀⠤⠤⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠒⠒⠒⠢⠤
⠀⠀⠀⠀⠀⠉⠀⢀⡠⠔⠛⠛⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠓⠒⠢⢄⣀⠀⠀
⠀⠀⠀⠀⠀⠀⠚⠉⠀⠀⠀⠀⠀⢀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠋⠉⠀⠀⠀⠀⠀⠀⠈⠑⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣇⠀⠀/ᐠ. .ᐟ\ฅ
EOF
)

function print_centered {
     [[ $# == 0 ]] && return 1
     declare -i TERM_COLS="$(tput cols)"
     declare -i str_len="${#1}"

     if [[ $str_len -ge $TERM_COLS ]]; then
          echo "$1"
          return 0
     fi

     declare -i filler_len="$(( (TERM_COLS - str_len) / 2 ))"
     [[ $# -ge 2 ]] && ch="${2:0:1}" || ch=" "

     # High-speed filler generation
     printf -v filler "%${filler_len}s" ""
     filler="${filler// /$ch}"

     printf "%s%s%s" "$filler" "$1" "$filler"
     [[ $(( (TERM_COLS - str_len) % 2 )) -ne 0 ]] && printf "%s" "${ch}"
     printf "\n"
}

final_output=""
while IFS= read -r line; do
    centered_line=$(print_centered "$line")
    final_output="${final_output}${centered_line}"
done <<< "$full_output"

echo -e "$final_output"
