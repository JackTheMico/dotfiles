#!/bin/bash

DOWNLOADS=$HOME/Downloads
NYXT=$HOME/Downloads/nyxt.tar.xz
TARGET=$HOME/.nyxt
 
if [[ ! -d "$DOWNLOADS" ]]; then
  mkdir "$DOWNLOADS" 
fi

if ! cd "$DOWNLOADS"; then
  echo "ERROR: can't access working directory ($DOWNLOADS)" >&2
  exit 1
fi

if [[ ! -f "$NYXT" ]]; then
  wget "https://github.com/atlas-engineer/nyxt/releases/download/2.2.4/nyxt-2.2.4.tar.xz" "$NYXT"
fi

if [[ ! -d "$TARGET" ]]; then
  mkdir "$TARGET"
fi

tar -xf "$NYXT" -C "$TARGET"
