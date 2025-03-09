#!/bin/bash

SESSION_NAME="main"

tmux has-session -t $SESSION_NAME 2>/dev/null
if [ $? != 0 ]; then
  tmux new-session -d -s $SESSION_NAME -n Zsh
  tmux send-keys -t $SESSION_NAME:1 'f' C-m

  # tmux new-window -t $SESSION_NAME:2 -n config -c $HOME/.config/
  # tmux send-keys -t $SESSION_NAME:2 'nvim' C-m
  #
  # tmux new-window -t $SESSION_NAME:3 -n Dotfiles -c $HOME/Dotfiles/
  # tmux send-keys -t $SESSION_NAME:3 'nvim' C-m
  #
  # tmux new-window -t $SESSION_NAME:4 -n scripts -c $HOME/.config/bnsplit/scripts/
  # tmux send-keys -t $SESSION_NAME:4 'nvim' C-m
  #
  # tmux new-window -t $SESSION_NAME:5 -n yazi -c $HOME/
  # tmux send-keys -t $SESSION_NAME:5 'yazi' C-m
  #
  # tmux new-window -t $SESSION_NAME:6 -n btop
  # tmux send-keys -t $SESSION_NAME:6 'btop' C-m
  #
  # tmux new-window -t $SESSION_NAME:7 -n tty-clock
  # tmux send-keys -t $SESSION_NAME:7 'tty-clock -sc' C-m

  # Bindings
  for i in $(seq 0 9); do
    tmux bind-key -n "M-$i" select-window -t $SESSION_NAME:$i
  done
  tmux bind-key -n "M-0" select-window -t $SESSION_NAME:10
fi

tmux attach -t $SESSION_NAME
tmux select-window -t $SESSION_NAME:1
