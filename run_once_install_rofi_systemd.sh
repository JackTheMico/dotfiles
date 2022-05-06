#!/bin/bash

rofiSystemd=$HOME/.rofi-systemd/rofi-systemd
target=$HOME/.local/bin/rofi-systemd

if [[ ! -f "$target" ]]; then
  chmod +x $rofiSystemd
  ln -s -f $rofiSystemd $target
fi
