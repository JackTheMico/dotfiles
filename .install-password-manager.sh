#!/bin/sh

# exit immediately if password-manager-binary is already in $PATH
type keepassxc-cli >/dev/null 2>&1 && exit

case "$(cat /etc/issue | cut -d ' ' -f1)" in
Darwin)
  # commands to install password-manager-binary on Darwin
  ;;
Manjaro)
  # commands to install password-manager-binary on Linux
  # use pacman because I use Manjaro
  sudo pacman-mirrors --country China
  sudo pacman -S --noconfirm --needed keepassxc
  ;;
Kali)
  sudo apt update
  sudo apt install -y keepassxc
  ;;
*)
  echo "unsupported OS"
  exit 0
  ;;
esac
