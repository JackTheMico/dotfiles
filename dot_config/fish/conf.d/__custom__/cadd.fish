function cadd --description 'Fuzzy search unmanaged files and add to chezmoi'
    # 1. 使用 chezmoi unmanaged 获取未管理的文件列表（相对 $HOME 的路径）
    # 2. fzf 加上 -m (multi-select) 允许按 Tab 多选
    # 3. 预览：直接查看 $HOME 下的实际文件内容
    set -l targets (chezmoi unmanaged 2>/dev/null | \
        fzf --multi --height 60% --layout=reverse \
            --header 'TAB: 多选 | Enter: 确认' \
            --preview 'bat --color=always $HOME/{} 2>/dev/null || cat $HOME/{}' \
            --preview-window=right:60%:wrap)

    if test (count $targets) -gt 0
        # cwd 不在 $HOME 时 chezmoi add 会拼错路径，给绝对路径
        set -l abs_targets
        for t in $targets
            set -a abs_targets "$HOME/$t"
        end
        chezmoi add $abs_targets

        for t in $targets
            echo "Added to chezmoi: $t"
        end
    end
end
