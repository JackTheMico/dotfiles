#!/bin/bash

target=$HOME/.local/bin/kubectl

if [[ ! -x "$target" ]]; then
  chmod +x $target
fi
