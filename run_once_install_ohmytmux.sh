#!/bin/bash
tmuxconfPath=$HOME/.tmux.conf
tmuxlocaPath=$HOME/.tmux.conf.local
translateGitPath=$HOME/.rofi-translate
rofiTransPath=$HOME/.local/bin/rofi_trans
rofiTransBriefPath=$HOME/.local/bin/rofi_trans_brief
rofiTransDeletePath=$HOME/.local/bin/rofi_trans_delete
rofiTransVerbosePath=$HOME/.local/bin/rofi_trans_verbose
rofiVerbosePath=$HOME/.local/bin/rofi_verbose

if [[ ! -f "$tmuxconfPath" ]]; then
  ln -s -f $HOME/.tmux/.tmux.conf $HOME/.tmux.conf
fi

if [[ ! -f "$tmuxlocaPath" ]]; then
  cp $HOME/.tmux/.tmux.conf.local $HOME/.tmux.conf.local
fi

if [[ ! -f "$rofiTransPath" ]]; then
  ln -s -f $HOME/.rofi-translate/rofi_trans $HOME/.local/bin/rofi_trans
fi

if [[ ! -f "$rofiTransBriefPath" ]]; then
  ln -s -f $HOME/.rofi-translate/rofi_trans_brief $HOME/.local/bin/rofi_trans_brief
fi

if [[ ! -f "$rofiTransDeletePath" ]]; then
  ln -s -f $HOME/.rofi-translate/rofi_trans_delete $HOME/.local/bin/rofi_trans_delete
fi

if [[ ! -f "$rofiTransVerbosePath" ]]; then
  ln -s -f $HOME/.rofi-translate/rofi_trans_verbose $HOME/.local/bin/rofi_trans_verbose
fi

if [[ ! -f "$rofiVerbosePath" ]]; then
  ln -s -f $HOME/.rofi-translate/rofi_verbose $HOME/.local/bin/rofi_verbose
fi
