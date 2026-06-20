# Auto-start tmux
if [[ -z "$TMUX" && -n "$PS1" && "$TERM_PROGRAM" != "vscode" && "$TERMINAL_EMULATOR" != "JetBrains-JediTerm" && "$TERM" != "linux" ]]; then
    tmux attach-session -t default 2>/dev/null || tmux new-session -s default
fi
