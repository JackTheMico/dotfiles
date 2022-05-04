#!/bin/bash

wget "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hack.zip"
sudo unzip Hack.zip -d /usr/share/fonts
sudo fc-cache -f -v
