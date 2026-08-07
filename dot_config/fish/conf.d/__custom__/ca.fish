function ca --description 'Fuzzy search, preview diff, and add update to chezmoi'
    argparse 'e/encrypt' -- $argv
    # 预览窗口展示目标文件与 chezmoi 源文件的 diff
    set -l targets (chezmoi managed 2>/dev/null | \
        fzf --multi --height 60% --layout=reverse \
            --header 'TAB: 多选 | Enter: 确认' \
            --preview 'chezmoi diff $HOME/{} 2>/dev/null | delta 2>/dev/null || chezmoi diff $HOME/{}' \
            --preview-window=right:60%:wrap)

    if test (count $targets) -gt 0
        # cwd 不在 $HOME 时 chezmoi add 会拼错路径，给绝对路径
        set -l abs_targets
        for t in $targets
            set -a abs_targets "$HOME/$t"
        end
        set -l enc
        if set -q _flag_encrypt
            set enc --encrypt
        end
        chezmoi add $enc $abs_targets

        for t in $targets
            echo "Added/Updated: $t"
        end
    end
end
