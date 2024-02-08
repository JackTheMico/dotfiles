#!/bin/bash

# Install softwares
sudo pacman-mirrors --quiet --country China
sudo pacman -Syu --noconfirm --quiet
if ! command -v yay &> /dev/null
then
  sudo pacman -S --noconfirm --needed --quiet yay
fi
softwares=(
  "atuin"
  "asciinema"
  "bat"
  "cargo"
  "carapace-bin"
  "carapace-bridge"
  "chezmoi"
  "fzf"
  "git"
  "keepassxc"
  "lazygit"
  "nushell"
  "tmux"
  "pyenv"
  "python-poetry"
  "python-pipx"
  "starship"
  "tig"
  "zoxide"
)
for software in "${softwares[@]}"
do
  if ! yay -Q "$software" &> /dev/null
  then
    yay -S --noconfirm --needed --quiet "$software"
  fi
done
