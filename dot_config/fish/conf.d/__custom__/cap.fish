function cap --description 'Fuzzy search, preview diff, and apply chezmoi source'
    set -l targets (chezmoi managed 2>/dev/null | \
        fzf --multi --height 60% --layout=reverse \
            --header 'TAB: 多选 | Enter: 确认' \
            --preview 'chezmoi diff $HOME/{} 2>/dev/null | delta 2>/dev/null || chezmoi diff $HOME/{}' \
            --preview-window=right:60%:wrap)

    if test (count $targets) -gt 0
        # cwd 不在 $HOME 时 chezmoi apply 会拼错路径，给绝对路径
        set -l abs_targets
        for t in $targets
            set -a abs_targets "$HOME/$t"
        end

        chezmoi apply $abs_targets

        for t in $targets
            echo "Applied: $t"
        end
    end
end
