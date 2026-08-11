function bwsettotp --description '为 Bitwarden 条目设置 TOTP 密钥（用 bw list items --search 查找）'
    argparse h/help l/list -- $argv
    or return 2

    if set -q _flag_help
        echo "用法: bwsettotp <搜索词> [TOTP密钥] [选项]"
        echo "  用 bw list items --search 查找 login 条目并设置/更新其 TOTP 密钥"
        echo "  -l, --list   只列出匹配条目与现有 TOTP，不修改"
        echo "  -h, --help   显示本帮助"
        echo
        echo "示例:"
        echo "  bwsettotp worldquant JBSWY3DPEHPK3PXP"
        echo "  bwsettotp github -l"
        return 0
    end

    set -l term $argv[1]
    set -l secret $argv[2]
    if test -z "$term"
        read -P '搜索词（条目名称/URL 片段）: ' term
    end
    test -n "$term"; or begin
        echo '错误：需要搜索词' >&2
        return 1
    end

    # ---- 确保 bw 已解锁 ----
    set -l st (bw status 2>/dev/null | jq -r .status)
    switch "$st"
        case unauthenticated
            echo 'bw 未登录，请先运行: bw login' >&2
            return 1
        case locked
            echo 'bw 已锁定，正在解锁...' >&2
            set -gx BW_SESSION (bw unlock --raw)
            or return 1
        case unlocked
            # 已解锁，继续
        case '*'
            echo "无法确定 bw 状态: $st" >&2
            return 1
    end

    # ---- 查找条目 ----
    set -l items (bw list items --search "$term" 2>/dev/null | jq -c '.[]? | select(.type == 1)')
    if test -z "$items"
        echo "没有找到匹配的 login 条目: $term" >&2
        return 1
    end

    # ---- 只查看模式：列出所有匹配条目后退出 ----
    if set -q _flag_list
        for item in $items
            set -l n (echo $item | jq -r .name)
            set -l u (echo $item | jq -r '.login.username // "-"')
            set -l t (echo $item | jq -r '.login.totp // ""')
            if test -n "$t"
                echo "$n   $u   TOTP: $t"
            else
                echo "$n   $u   TOTP: (无)"
            end
        end
        return 0
    end

    set -l item
    if test (count $items) -gt 1
        echo '匹配到多个条目:'
        for i in (seq (count $items))
            echo "$i. "(echo $items[$i] | jq -r '"\(.name)   \(.login.username // "-")"')
        end
        read -P '选择序号: ' idx
        set item $items[$idx]
        test -n "$item"; or begin
            echo 序号无效 >&2
            return 1
        end
    else
        set item $items[1]
    end

    set -l id (echo $item | jq -r .id)
    set -l old (echo $item | jq -r '.login.totp // ""')
    set -l display_name (echo $item | jq -r .name)
    set -l display_user (echo $item | jq -r '.login.username // "-"')

    # ---- 获取密钥 ----
    if test -z "$secret"
        read -P 'TOTP 密钥（base32 或 otpauth:// URI）: ' secret
    end
    test -n "$secret"; or begin
        echo '错误：密钥不能为空' >&2
        return 1
    end

    # ---- 写入 ----
    bw get item "$id" \
        | jq --arg s "$secret" '.login.totp = $s' \
        | bw encode | bw edit item "$id" \
        | jq -r '"已保存: \(.name) (id: \(.id))"'
    or return 1

    echo '✅ TOTP 设置完成'
    echo "  条目:   $display_name"
    echo "  用户名: $display_user"
    if test -n "$old"; and test "$old" != "$secret"
        echo "  旧密钥: $old"
    end
    echo "  新密钥: $secret"
    echo '  下一步: rbw sync 之后用 rbw code <名称> 取验证码'
end
