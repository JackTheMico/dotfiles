#!/bin/bash
tmuxconfPath=$HOME/.tmux.conf
tmuxlocaPath=$HOME/.tmux.conf.local

if [[ ! -f "$tmuxconfPath" ]]; then
  ln -s -f $HOME/.tmux/.tmux.conf $HOME/.tmux.conf
fi

if [[ ! -f "$tmuxlocaPath" ]]; then
  cp $HOME/.tmux/.tmux.conf.local $HOME/.tmux.conf.local
fi

