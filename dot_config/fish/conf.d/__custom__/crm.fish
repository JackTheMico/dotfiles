function crm --description 'Fuzzy search and forget (stop tracking) files'
    set -l targets (chezmoi managed 2>/dev/null | \
        fzf --multi --height 60% --layout=reverse \
            --header 'TAB: 多选 | Enter: 确认' \
            --preview 'bat --color=always $HOME/{} 2>/dev/null || cat $HOME/{}' \
            --preview-window=right:60%:wrap)

    if test (count $targets) -gt 0
        echo "Selected:"
        for t in $targets
            echo "  $t"
        end

        read -P "Forget these files? [y/N]: " confirm
        if test "$confirm" = y -o "$confirm" = Y
            # cwd 不在 $HOME 时给绝对路径
            set -l abs_targets
            for t in $targets
                set -a abs_targets "$HOME/$t"
            end
            chezmoi forget $abs_targets

            for t in $targets
                echo "Forgot: $t"
            end
        end
    end
end
