function vf --description 'Search files and open in nvim'
    set -l file (fd --type f --hidden --exclude .git 2>/dev/null | \
    fzf --multi --height 60% --layout=reverse --preview 'bat --color=always {} 2>/dev/null || cat {}' --preview-window=right:50%:wrap)
    if test -n "$file"
        nvim $file
    end
end
