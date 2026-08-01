function ce --description 'Fuzzy search chezmoi managed files and edit'
    # 使用 chezmoi managed 获取相对路径，fzf 预览实际文件内容
    set -l targets (chezmoi managed 2>/dev/null | \
        fzf --multi --height 60% --layout=reverse \
            --header 'TAB: 多选 | Enter: 确认' \
            --preview 'bat --color=always $HOME/{} 2>/dev/null || cat $HOME/{}' \
            --preview-window=right:60%:wrap)

    if test (count $targets) -gt 0
        # cwd 不在 $HOME 时给绝对路径
        set -l abs_targets
        for t in $targets
            set -a abs_targets "$HOME/$t"
        end
        chezmoi edit $abs_targets
    end
end
