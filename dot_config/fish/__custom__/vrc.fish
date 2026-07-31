function vrc --description 'Search and edit neovim config files'
    set -l config_dir "$HOME/.config/nvim"
    if test ! -d $config_dir
        echo "Neovim config directory not found at $config_dir"
        return 1
    end
    set -l file (fd . --type f --hidden $config_dir 2>/dev/null | \
    fzf --multi --height 60% --layout=reverse --preview 'bat --color=always {} 2>/dev/null || cat {}' --preview-window=right:50%:wrap)
    if test -n "$file"
        nvim $file
    end
end
