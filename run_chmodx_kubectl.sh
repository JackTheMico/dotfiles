#!/bin/bash

target=$HOME/.local/bin/kubuctl

if [[ ! -x "$target" ]]; then
  chmod +x $target
fi
