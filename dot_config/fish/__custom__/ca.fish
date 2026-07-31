function ca --description 'Fuzzy search, preview diff, and add update to chezmoi'
    # 预览窗口展示目标文件与 chezmoi 源文件的 diff
    set -l target (chezmoi managed 2>/dev/null | \
    fzf --height 40% --layout=reverse \
        --preview 'chezmoi diff $HOME/{} 2>/dev/null | delta 2>/dev/null || chezmoi diff $HOME/{}' \
        --preview-window=right:60%:wrap)

    if test -n "$target"
        chezmoi add "$HOME/$target"
        echo "Added/Updated: $target"
    end
end
