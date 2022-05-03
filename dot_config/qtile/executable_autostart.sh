#!/usr/bin/env bash 

systemctl --user start greenclip.service
systemctl --user start himalaya-watcher
touch /tmp/himalaya-counter
fcitx5 &
