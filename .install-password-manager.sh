#!/bin/sh

# exit immediately if password-manager-binary is already in $PATH
type keepassxc-cli >/dev/null 2>&1 && exit

case "$(uname -s)" in
Darwin)
    # commands to install password-manager-binary on Darwin
    ;;
Linux)
    # commands to install password-manager-binary on Linux
    # use pacman because I use Manjaro
    sudo pacman-mirrors --country China
    sudo pacman -S --noconfirm --needed keepassxc
    ;;
*)
    echo "unsupported OS"
    exit 1
    ;;
esac
