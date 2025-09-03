if status is-interactive
    # Commands to run in interactive sessions can go here
end
set -gx EDITOR nvim
set -gx GPG_TTY $(tty)
set -gx PATH $HOME/.local/bin $PATH
set -gx PNPM_HOME $HOME/pnpm_home
set -gx PATH $HOME/pnpm_home $PATH
set -gx PATH $HOME/.cargo/bin $PATH

zoxide init fish | source
starship init fish | source
alias czi chezmoi
alias ls eza
alias la 'eza -a'
alias lt 'eza -T'
alias md mkdir
alias lg lazygit
alias ff fastfetch
alias efish 'czi edit ~/.config/fish/config.fish'
alias refish 'source ~/.config/fish/config.fish'
