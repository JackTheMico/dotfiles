function ce --description 'Fuzzy search chezmoi managed files and edit'
    # 使用 chezmoi managed 获取相对路径，fzf 预览实际文件内容
    set -l target (chezmoi managed 2>/dev/null | \
    fzf --height 40% --layout=reverse \
        --preview 'bat --color=always $HOME/{} 2>/dev/null || cat $HOME/{}' \
        --preview-window=right:60%:wrap)

    if test -n "$target"
        # cwd 不在 $HOME 时给绝对路径
        chezmoi edit "$HOME/$target"
    end
end
