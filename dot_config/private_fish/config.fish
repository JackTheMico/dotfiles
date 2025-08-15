if status is-interactive
    # Commands to run in interactive sessions can go here
end
set -gx EDITOR nvim

zoxide init fish | source
starship init fish | source
alias czi chezmoi
alias md mkdir
alias lg lazygit
alias ff fastfetch
