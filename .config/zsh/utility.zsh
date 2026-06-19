# █   █   █     ▀    ▀█     ▀     █
# █   █  ▀█▀   ▀█     █    ▀█    ▀█▀  █   █
# █   █   █     █     █     █     █   █   █
# ▀▄▄▄▀   ▀▄▄  ▄█▄    ▀▄▄  ▄█▄    ▀▄▄ ▀▄▄▄█
#                                      ▄▄▄▀

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

function _smooth_fzf() {
  local fname
  local current_dir="$PWD"
  cd "${XDG_CONFIG_HOME:-~/.config}"
  fname="$(fzf)" || return
  $EDITOR "$fname"
  cd "$current_dir"
}

function _sudo_replace_buffer() {
  local old=$1 new=$2 space=${2:+ }

  # if the cursor is positioned in the $old part of the text, make
  # the substitution and leave the cursor after the $new text
  if [[ $CURSOR -le ${#old} ]]; then
    BUFFER="${new}${space}${BUFFER#$old }"
    CURSOR=${#new}
  # otherwise just replace $old with $new in the text before the cursor
  else
    LBUFFER="${new}${space}${LBUFFER#$old }"
  fi
}

function _sudo_command_line() {
  # If line is empty, get the last run command from history
  [[ -z $BUFFER ]] && LBUFFER="$(fc -ln -1)"

  # Save beginning space
  local WHITESPACE=""
  if [[ ${LBUFFER:0:1} = " " ]]; then
    WHITESPACE=" "
    LBUFFER="${LBUFFER:1}"
  fi

  {
    # If $SUDO_EDITOR or $VISUAL are defined, then use that as $EDITOR
    # Else use the default $EDITOR
    local EDITOR=${SUDO_EDITOR:-${VISUAL:-$EDITOR}}

    # If $EDITOR is not set, just toggle the sudo prefix on and off
    if [[ -z "$EDITOR" ]]; then
      case "$BUFFER" in
        sudo\ -e\ *) _sudo_replace_buffer "sudo -e" "" ;;
        sudo\ *) _sudo_replace_buffer "sudo" "" ;;
        *) LBUFFER="sudo $LBUFFER" ;;
      esac
      return
    fi

    # Check if the typed command is really an alias to $EDITOR

    # Get the first part of the typed command
    local cmd="${${(Az)BUFFER}[1]}"
    # Get the first part of the alias of the same name as $cmd, or $cmd if no alias matches
    local realcmd="${${(Az)aliases[$cmd]}[1]:-$cmd}"
    # Get the first part of the $EDITOR command ($EDITOR may have arguments after it)
    local editorcmd="${${(Az)EDITOR}[1]}"

    # Note: ${var:c} makes a $PATH search and expands $var to the full path
    # The if condition is met when:
    # - $realcmd is '$EDITOR'
    # - $realcmd is "cmd" and $EDITOR is "cmd"
    # - $realcmd is "cmd" and $EDITOR is "cmd --with --arguments"
    # - $realcmd is "/path/to/cmd" and $EDITOR is "cmd"
    # - $realcmd is "/path/to/cmd" and $EDITOR is "/path/to/cmd"
    # or
    # - $realcmd is "cmd" and $EDITOR is "cmd"
    # - $realcmd is "cmd" and $EDITOR is "/path/to/cmd"
    # or
    # - $realcmd is "cmd" and $EDITOR is /alternative/path/to/cmd that appears in $PATH
    if [[ "$realcmd" = (\$EDITOR|$editorcmd|${editorcmd:c}) \
      || "${realcmd:c}" = ($editorcmd|${editorcmd:c}) ]] \
      || builtin which -a "$realcmd" | command grep -Fx -q "$editorcmd"; then
      _sudo_replace_buffer "$cmd" "sudo -e"
      return
    fi

    # Check for editor commands in the typed command and replace accordingly
    case "$BUFFER" in
      $editorcmd\ *) _sudo_replace_buffer "$editorcmd" "sudo -e" ;;
      \$EDITOR\ *) _sudo_replace_buffer '$EDITOR' "sudo -e" ;;
      sudo\ -e\ *) _sudo_replace_buffer "sudo -e" "$EDITOR" ;;
      sudo\ *) _sudo_replace_buffer "sudo" "" ;;
      *) LBUFFER="sudo $LBUFFER" ;;
    esac
  } always {
    # Preserve beginning space
    LBUFFER="${WHITESPACE}${LBUFFER}"

    # Redisplay edit buffer (compatibility with zsh-syntax-highlighting)
    zle redisplay
  }
}

function _vi_search_fix() {
  zle vi-cmd-mode
  zle .vi-history-search-backward
}

function toppy() {
    history | awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl |  head -n 21
}

#function cd() {
#	builtin cd "$@" && command ls --group-directories-first --color=auto -F
#}
chpwd() {
    ls --group-directories-first --color=auto -F
}

function pacclean() {
    local orphans=$(pacman -Qtdq)
    if [[ -n "$orphans" ]]; then
        echo "$orphans" | fzf -m --header "Select orphans to remove" | xargs -ro sudo pacman -Rns
    else
        echo "No orphans found."
    fi
}

function fkill() {
    local pid
    pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    if [ "x$pid" != "x" ]; then
        echo $pid | xargs kill -${1:-9}
    fi
}

ffconvert() {
    if [ "$#" -ne 2 ]; then
        echo "Usage: ffconvert input_file output_file"
        return 1
    fi

    local input="$1"
    local output="$2"
    local ext="${output##*.}"

    if [[ "$input" =~ \.mkv$ ]] && [[ "$output" =~ \.mp4$ ]]; then
        ffmpeg -i "$input" -c copy -map 0 "$output"
    else
        ffmpeg -vaapi_device /dev/dri/renderD128 -i "$input" -vf "format=nv12,hwupload" -c:v h264_vaapi -qp 24 "$output"
    fi
}

function git-svn(){
  if [[ ! -z "$1" && ! -z "$2" ]]; then
          echo "Starting clone/copy ..."
          repo=$(echo $1 | sed 's/\/$\|.git$//')
          svn export "$repo/trunk/$2"
  else
          echo "Use: git-svn <repository> <subdirectory>"
  fi
}
#default modifications
command_not_found_handler(){
    printf "\033[1;38;2;254;128;25m%s\033[0m not found\n" "$1"
    return 127
}
# Smart clear function
cls() {
    if [[ "$TERM" == "st"* ]]; then
        printf "\033c"
    else
        printf "\033[2J\033[3J\033[H"
    fi
}


run() {
    local file=$1
    if [[ -z "$file" ]]; then
        if [ -f justfile ] || [ -f Justfile ]; then
            just "${@}"
        else
            make "${@}"
        fi
        return 0
    fi

    if [[ ! -f "$file" ]] || [[ -d "$file" ]]; then
        printf "\033[31;1;4mError:\033[0m File %s not found.\n" "$file"
        return 1
    fi

    local ext="${file##*.}"
    local filename="${file%.*}"

    shift # Removes $1 (the file). Now "${@}" contains ONLY your extra flags/arguments.

    case "$ext" in
        clj)  clojure -M "$file" "${@}" ;;
        lisp) sbcl --script "$file" "${@}" ;;
        zig)  zig run "$file" -- "${@}" ;; # Zig requires -- to separate runner flags from binary args
        odin) odin run "$file" -file -- "${@}" ;;
        js)   node "$file" "${@}" ;;
        cs)   mcs "$file" && mono "${filename}.exe" "${@}" ;;
        tcl)  tclsh "$file" "${@}" ;;
        c)    if command -v c >/dev/null 2>&1; then command c "$file" "${@}"; else gcc "$file" -o "$filename" && ./"$filename" "${@}"; fi ;;
        cpp)  g++ "$file" -o "$filename" && ./"$filename" "${@}" ;;
        go)   go run "$file" "${@}" ;;
        rs)   rustc "$file" && ./"$filename" "${@}" ;;
        py)   pypy "$file" "${@}" ;;
        rb)   ruby "$file" "${@}" ;;
        java) javac "$file" && java "$filename" "${@}" ;;
        lua)  lua "$file" "${@}" ;;
        sh)   bash "$file" "${@}" ;;
        nim)  nim c -r "$file" "${@}" ;;
        elx|ex|exs) elixir "$file" "${@}" ;;
        qml)  qs -p "$file" "${@}" ;;
        ml)   ocaml "$file" "${@}" ;;
        *)    echo "Error: Unsupported extension '.$ext'" ;;
    esac
}



# Usage: extract <file>
# Description: extracts archived files / mounts disk images
# Note: .dmg/hdiutil is macOS-specific.
#
# credit: http://nparikh.org/notes/zshrc.txt
extract () {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.tar) tar -xvf "$1"       ;;
            *.7z)       7z x "$1"                           ;;
            *.bz2)      bunzip2 "$1"                        ;;
            *.dmg)      hdiutil mount "$1"                  ;;
            *.gz)       gunzip "$1"                         ;;
            *.zip|*.ZIP) unzip "$1"                         ;;
            *.pax)      pax -r < "$1"                       ;;
            *.pax.Z)    uncompress "$1" --stdout | pax -r   ;;
            *.rar)      unrar x "$1"                        ;;
            *.Z)        uncompress "$1"                     ;;
            *)          echo "'$1' cannot be extracted/mounted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# vim:ft=sh
