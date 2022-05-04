#!/usr/bin/env bash 

systemctl --user start greenclip.service
systemctl --user start himalaya-watcher
touch /tmp/himalaya-counter
picom -bc --active-opacity 0.9
nutstore &
fcitx5 &
