#!/usr/bin/env fish
#
# Copyright (c) 2020 Rich Lewis
# License: MIT

abbr po 'poetry'
abbr pon 'poetry new --src'
abbr poin 'poetry init'
abbr poi 'poetry install'
abbr poup 'poetry update'
abbr poa 'poetry add'
abbr porm 'poetry remove'
abbr pos 'poetry show'
abbr pob 'poetry build'
abbr pop 'poetry publish'
abbr poc 'poetry config'
abbr por 'poetry run'
abbr posh 'poetry shell'
abbr pock 'poetry check'
abbr pof 'poetry search'
abbr pol 'poetry lock'
abbr pov 'poetry version'
abbr pox 'poetry export'
abbr poe 'poetry env'

set -l name (basename (status -f) .fish){_uninstall}

function $name --on-event $name
    abbr -e po
    abbr -e pon
    abbr -e poin
    abbr -e 
    abbr -e poup
    abbr -e poa
    abbr -e porm
    abbr -e pos
    abbr -e pob
    abbr -e pop
    abbr -e poc
    abbr -e por
    abbr -e posh
    abbr -e pock
    abbr -e pof
    abbr -e pol
    abbr -e pov
    abbr -e pox
    abbr -e poe
end
