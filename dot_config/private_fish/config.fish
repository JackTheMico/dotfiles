if status is-interactive
    # Commands to run in interactive sessions can go here
end
set -gx EDITOR nvim
set -gx GPG_TTY $(tty)
set -gx http_proxy 'http://127.0.0.1:7897'
set -gx https_proxy 'http://127.0.0.1:7897'
set -gx PATH $HOME/.local/bin $PATH

zoxide init fish | source
starship init fish | source
alias czi chezmoi
alias md mkdir
alias lg lazygit
alias ff fastfetch
alias efish 'czi edit ~/.config/fish/config.fish'
alias refish 'source ~/.config/fish/config.fish'
