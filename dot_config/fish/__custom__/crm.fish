function crm --description 'Fuzzy search and forget (stop tracking) a file'
    set -l target (chezmoi managed 2>/dev/null | \
    fzf --multi --height 40% --layout=reverse \
        --preview 'bat --color=always $HOME/{} 2>/dev/null || cat $HOME/{}' \
        --preview-window=right:60%:wrap)

    if test -n "$target"
        read -P "Forget (stop tracking) '$target'? [y/N]: " confirm
        if test "$confirm" = y -o "$confirm" = Y
            chezmoi forget "$HOME/$target"
            echo "Forgot: $target"
        end
    end
end
