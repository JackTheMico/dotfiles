function rbwadd --description '快速添加 Bitwarden 条目（rbw）：自定义或自动生成密码，可选 URI/folder'
    argparse h/help q/quiet 'u/uri=' 'f/folder=' 'l/len=' s/symbols 'p/password=' -- $argv
    or return 2

    if set -q _flag_help
        echo "用法: rbwadd <名称> [用户名] [选项]"
        echo "  -p, --password <密码>  使用自己的密码（代替自动生成）"
        echo "  -u, --uri <URL>        关联的网站 URL"
        echo "  -f, --folder <名称>    放入的文件夹"
        echo "  -l, --len <N>          自动生成密码长度（默认 20）"
        echo "  -s, --symbols          自动生成时含特殊符号"
        echo "  -q, --quiet            不打印密码"
        echo "  -h, --help             显示本帮助"
        echo
        echo "密码来源优先级: -p 参数 > 交互输入（不回显）> 自动生成"
        return 0
    end

    # 位置参数
    set -l name $argv[1]
    set -l user $argv[2]

    # 交互补齐缺失项
    if test -z "$name"
        read -P '条目名称: ' name
    end
    if test -z "$user"
        read -P '用户名（回车跳过）: ' user
    end
    if not set -q _flag_uri
        read -P 'URI（回车跳过）: ' _flag_uri
    end
    if test -z "$name"
        echo "错误：条目名称不能为空" >&2
        return 1
    end
    set -q _flag_len; or set -l _flag_len 20

    # ---- 密码来源 ----
    set -l pass
    if set -q _flag_password
        # ① 命令行参数直接给
        set pass $_flag_password
    else
        # ② 交互输入自己的密码（隐藏回显）；留空则自动生成
        stty -echo 2>/dev/null
        read -P '输入密码（回车留空=自动生成）: ' pass
        stty echo 2>/dev/null
        echo ''
        if test -z "$pass"
            # ③ 自动生成
            if set -q _flag_symbols
                set pass (openssl rand -base64 32 | tr -dc 'A-Za-z0-9!@#$%^&*+-_=' | head -c $_flag_len)
            else
                set pass (openssl rand -base64 32 | tr -dc 'A-Za-z0-9' | head -c $_flag_len)
            end
        end
    end

    # 组装参数（空值不传）
    set -l add_args $name
    test -n "$user"; and set -a add_args $user
    set -q _flag_uri; and set -a add_args --uri $_flag_uri
    set -q _flag_folder; and set -a add_args --folder $_flag_folder

    # 管道传密码 → 不打开编辑器
    printf '%s\n' $pass | rbw add $add_args
    or return 1

    if not set -q _flag_quiet
        echo "✅ 已添加: $name"
        echo "   密码: $pass"
    end
end
