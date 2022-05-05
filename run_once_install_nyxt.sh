#!/bin/bash

DOWNLOADS=$HOME/Downloads
NYXT=$HOME/Downloads/nyxt.tar.xz
TARGET=$HOME/.nyxt
NYXTBIN=$HOME/.nyxt/usr/local/bin/nyxt
HOMEBIN=$HOME/.local/bin/nyxt
 
if [[ ! -d "$DOWNLOADS" ]]; then
  mkdir "$DOWNLOADS" 
fi

if ! cd "$DOWNLOADS"; then
  echo "ERROR: can't access working directory ($DOWNLOADS)" >&2
  exit 1
fi

if [[ ! -d "$TARGET" ]]; then
  mkdir "$TARGET"
fi

if [[ ! -f "$NYXT" ]]; then
  wget "https://github.com/atlas-engineer/nyxt/releases/download/2.2.4/nyxt-2.2.4.tar.xz" -O "$NYXT"
  tar -xf "$NYXT" -C "$TARGET"
  ln -sf "$NYXTBIN" "HOMEBIN" 
fi
