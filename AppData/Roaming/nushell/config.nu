# config.nu
#
# Installed by:
# version = "0.105.1"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# This file is loaded after env.nu and before login.nu
#
# You can open this file in your default editor using:
# config nu
#
# See `help config nu` for more options
#
# You can remove these comments if you want or leave
# them for future reference.

# zoxide
source ~/.zoxide.nu

# starship
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

# proxy
$env.http_proxy = "http://localhost:7897"
$env.https_proxy = "http://localhost:7897"
$env.no_proxy = "localhost,127.0.0.1"
# EDITOR
$env.EDITOR = "nvim"

# Key Bindings
$env.config.keybindings ++= [
  {
     name: fuzzy_file
     modifier: control
     keycode: char_t
     mode: [vi_normal, vi_insert]
     event: {
       send: executehostcommand
       cmd: "commandline edit --replace (fzf --layout=reverse)"
     }
  },
  {
    name: fuzzy_history
    modifier: control
    keycode: char_r
    mode: emacs
    event: {
      send: executehostcommand
      cmd: "commandline edit --replace (history | each { |it| $it.command } | uniq | reverse | fzf --layout=reverse --height=40% -q (commandline) | decode utf-8 | str substring 12..-1)"
    }
  },
  {
    name: change_dir_with_fzf
    modifier: control
    keycode: char_f
    mode: emacs
    event: {
      send: executehostcommand,
      cmd: "cd (ls | where type == dir | get name | str join (char newline) | fzf | decode utf-8 | str trim)"
    }
  }
]

# Starship
$env.STARSHIP_SHELL = "nu"

def create_left_prompt [] {
    starship prompt --cmd-duration $env.CMD_DURATION_MS $'--status=($env.LAST_EXIT_CODE)'
}

# Use nushell functions to define your right and left prompt
$env.PROMPT_COMMAND = { create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = ""

# The prompt indicators are environmental variables that represent
# the state of the prompt
$env.PROMPT_INDICATOR = ""
$env.PROMPT_INDICATOR_VI_INSERT = ": "
$env.PROMPT_INDICATOR_VI_NORMAL = "〉"
$env.PROMPT_MULTILINE_INDICATOR = "::: "

# alias
alias czi = chezmoi
alias lg = lazygit
alias ff = fastfetch
