# 1. ce: 模糊查找并编辑 chezmoi 管理的文件 (Edit)
function ce --description 'Fuzzy search chezmoi managed files and edit'
    # 使用 chezmoi managed 获取相对路径，fzf 预览实际文件内容
    set -l target (chezmoi managed 2>/dev/null | \
    fzf --height 40% --layout=reverse \
        --preview 'bat --color=always "$HOME/{}" 2>/dev/null || cat "$HOME/{}"' \
        --preview-window=right:60%:wrap)

    if test -n "$target"
        # chezmoi edit 会自动使用 $EDITOR (即 nvim) 打开源文件
        chezmoi edit $target
    end
end

# 2. ca: 模糊查找文件，预览差异，并捕获更新到源目录
function ca --description 'Fuzzy search, preview diff, and add update to chezmoi'
    # 预览窗口展示目标文件与 chezmoi 源文件的 diff
    set -l target (chezmoi managed 2>/dev/null | \
    fzf --height 40% --layout=reverse \
        --preview 'chezmoi diff {} 2>/dev/null | delta 2>/dev/null || chezmoi diff {}' \
        --preview-window=right:60%:wrap)

    if test -n "$target"
        # 执行 add 将当前状态保存回 chezmoi 源
        chezmoi add $target
        echo "Added/Updated: $target"
    end
end

# 3. cap: 模糊查找文件，预览差异，并应用源文件到当前系统 (Apply)
function cap --description 'Fuzzy search, preview diff, and apply chezmoi source'
    set -l target (chezmoi managed 2>/dev/null | \
    fzf --height 40% --layout=reverse \
        --preview 'chezmoi diff {} 2>/dev/null | delta 2>/dev/null || chezmoi diff {}' \
        --preview-window=right:60%:wrap)

    if test -n "$target"
        # 执行 apply 将源文件同步到实际位置
        chezmoi apply $target
        echo "Applied: $target"
    end
end

# 4. crm: 模糊查找并停止追踪文件
function crm --description 'Fuzzy search and forget (stop tracking) a file'
    set -l target (chezmoi managed 2>/dev/null | \
    fzf --height 40% --layout=reverse \
        --preview 'bat --color=always "$HOME/{}" 2>/dev/null || cat "$HOME/{}"' \
        --preview-window=right:60%:wrap)

    if test -n "$target"
        # 忘记文件需要确认，防止误操作
        read -P "Forget (stop tracking) '$target'? [y/N]: " confirm
        if test "$confirm" = y -o "$confirm" = Y
            chezmoi forget $target
            echo "Forgot: $target"
        end
    end
end

# 5. cadd: 模糊查找未管理的文件并添加到 chezmoi (支持多选)
function cadd --description 'Fuzzy search unmanaged files and add to chezmoi'
    # 1. 使用 chezmoi unmanaged 获取未管理的文件列表（相对 $HOME 的路径）
    # 2. fzf 加上 -m (multi-select) 允许按 Tab 多选
    # 3. 预览：直接查看 $HOME 下的实际文件内容
    set -l targets (chezmoi unmanaged 2>/dev/null | \
    fzf --multi --height 60% --layout=reverse \
        --preview 'bat --color=always "$HOME/{}" 2>/dev/null || cat "$HOME/{}"' \
        --preview-window=right:60%:wrap)

    if test -n "$targets"
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
