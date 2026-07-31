function cap --description 'Fuzzy search, preview diff, and apply chezmoi source'
    set -l target (chezmoi managed 2>/dev/null | \
    fzf --height 40% --layout=reverse \
        --preview 'chezmoi diff $HOME/{} 2>/dev/null | delta 2>/dev/null || chezmoi diff $HOME/{}' \
        --preview-window=right:60%:wrap)

    if test -n "$target"
        chezmoi apply "$HOME/$target"
        echo "Applied: $target"
    end
end
