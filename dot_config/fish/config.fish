if test -f /usr/share/cachyos-fish-config/cachyos-config.fish
    source /usr/share/cachyos-fish-config/cachyos-config.fish
end

# yazi
function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    command yazi $argv --cwd-file="$tmp"
    if read -z cwd <"$tmp"; and [ "$cwd" != "$PWD" ]; and test -d "$cwd"
        builtin cd -- "$cwd"
    end
    command rm -f -- "$tmp"
end

alias refish='source ~/.config/fish/config.fish'
alias efish='nvim ~/.config/fish/config.fish'
alias czi=chezmoi
alias pu=paruse
alias lg=lazygit
alias md=mkdir

# 代理配置 (Proxy Configuration) — 修改此处以适配你的代理端口
set -g PROXY_ADDR "127.0.0.1:7890"

# sudoedit
set -gx SUDO_EDITOR nvim
set -gx EDITOR nvim
set -gx BROWSER qutebrowser

# 开启代理
function proxy_on
    set -gx http_proxy "http://$PROXY_ADDR"
    set -gx https_proxy "http://$PROXY_ADDR"
    set -gx all_proxy "socks5://$PROXY_ADDR"
    echo "[+] 终端代理已开启 (Proxy: $PROXY_ADDR)"
end

# 关闭代理
function proxy_off
    set -e http_proxy
    set -e https_proxy
    set -e all_proxy
    echo "[-] 终端代理已关闭"
end

# yt-dlp music
function ytbi
    yt-dlp -x --audio-format mp3 --audio-quality 0 --embed-thumbnail --add-metadata --cookies-from-browser firefox $argv
end

# 查看代理状态
function proxy_status
    echo "--- 代理环境变量 (Proxy Env) ---"
    for var in http_proxy https_proxy all_proxy
        if set -q $var
            echo "$var: "$$var
        else
            echo "$var: [未设置]"
        end
    end

    echo ""
    echo "--- 连通性测试 (Connectivity) ---"
    echo -n "测试 Google.com... "
    set -l start (date +%s%3N)
    set -l code (curl -I -s --connect-timeout 3 -o /dev/null -w "%{http_code}" https://www.google.com 2>/dev/null)
    set -l end (date +%s%3N)
    if test "$code" = 200 -o "$code" = 301 -o "$code" = 302
        set -l duration (math $end - $start)
        echo "成功 (HTTP $code, $duration ms)"
    else
        echo 失败
    end

    echo ""
    echo "--- IP 地理位置 (IP Location) ---"
    curl -s -m 3 cip.cc 2>/dev/null | head -n 3
end

function ask_agy
    proxy_on
    agy $argv
end

# Added by Antigravity CLI installer
fish_add_path -m "$HOME/.local/bin"

if status is-interactive
    # No greeting
    set fish_greeting

    # Tab 智能自动补全
    #  - 补全菜单已显示 → 在选项间导航（选择下一个候选项）
    #  - 有灰色自动建议 → 优先采纳建议
    #  - 无建议可采纳 → 弹出补全菜单
    function custom_tab_complete
        # 若补全菜单（pager）已显示，直接导航到下一选项
        if commandline -P
            commandline -f complete
            return
        end

        # 尝试采纳灰色自动建议
        set -l cmd_before (commandline)
        commandline -f accept-autosuggestion

        if test (commandline) != "$cmd_before"
            # 成功采纳了灰色建议
            return
        end

        # 无建议可采纳，弹出补全菜单
        commandline -f complete
    end

    function fish_user_key_bindings
        # 绑定 Tab 键
        bind \t custom_tab_complete
    end

    # Use starship prompt
    if command -v starship &>/dev/null
        starship init fish | source
    end

    # Apply terminal color sequences (Material You from wallpaper)
    if test -f ~/.local/state/quickshell/user/generated/terminal/sequences.txt
        cat ~/.local/state/quickshell/user/generated/terminal/sequences.txt
    end

    # Aliases
    alias clear "printf '\033[2J\033[3J\033[1;1H'" # fix: kitty doesn't clear scrollback properly
    alias celar "printf '\033[2J\033[3J\033[1;1H'"
    alias claer "printf '\033[2J\033[3J\033[1;1H'"

    # Shelly 统一包管理别名 (CachyOS 官方推荐)
    alias up='shelly upgrade-all' # 一键更新官方包、AUR、Flatpak、AppImage
    alias update='shelly upgrade-all' # 同上，完整拼写
    alias in='shelly install' # 安装软件包 (支持官方源/AUR/Flatpak)
    alias un='shelly remove' # 卸载软件包
    alias se='shelly query' # 搜索/查询软件包
    alias clean='~/.config/fish/clean-cache' # 运行一键缓存清理脚本

    # 自定义指令与别名总览说明 (Custom Commands & Aliases Help)
    function custom_help
        echo "=== 终端自定义快捷指令 (Custom Commands & Aliases) ==="
        echo ""
        echo "  --- NyxNiri 配置工具与快照恢复 (NyxNiri CLI & Snapshots) ---"
        echo "  nyxniri                    -> 打开 NyxNiri 桌面控制面板主菜单"
        echo "  nyxniri snapshot [备注]    -> 手动创建当前配置快照"
        echo "  nyxniri rollback [序号]    -> 恢复指定的历史配置快照"
        echo "  nyxniri list               -> 列出所有可用的配置快照"
        echo "  nyxniri uninstall          -> 安全卸载并复原系统配置环境"
        echo "  nyxniri doctor             -> 运行系统诊断检查"
        echo ""
        echo "  --- 代理控制 (Proxy Controls) ---"
        echo "  proxy_on       -> 开启终端代理 (Socks5/HTTP :7890)"
        echo "  proxy_off      -> 关闭终端代理"
        echo "  proxy_status   -> 检查代理连通性及公网 IP 位置"
        echo ""
        echo "  --- 包管理 (Package Management - Shelly) ---"
        echo "  up / update    -> shelly upgrade-all"
        echo "                    (一键更新官方包、AUR、Flatpak、AppImage)"
        echo "  in <包名>      -> shelly install <包名>"
        echo "                    (安装软件包，支持官方/AUR/Flatpak)"
        echo "  un <包名>      -> shelly remove <包名>"
        echo "                    (卸载并清理软件包)"
        echo "  se <关键字>    -> shelly query <关键字>"
        echo "  clean          -> ~/.config/fish/clean-cache"
        echo "                    (一键清理系统与用户缓存，包含多维度清理)"
        echo ""
        echo "  --- 智能自动补全与模糊搜索 (Autocomplete & Fuzzy Search) ---"
        echo "  Tab            -> 优先采纳灰色历史建议，无建议时触发 Tab 列表补全"
        echo "  Ctrl + R       -> 模糊搜索历史命令 (fzf 历史记录)"
        echo "  Ctrl + Alt + F -> 模糊查找文件并插入路径 (fzf 文件)"
        echo "  Ctrl + Alt + L -> 模糊浏览 git commit 历史 (fzf Git Log)"
        echo "  Ctrl + Alt + S -> 模糊浏览 git status 状态 (fzf Git Status)"
        echo "  (提示: 括号和单双引号均已配置自动双向配对补全)"
        echo ""
        echo "提示: 可用 'custom_help'、'pkg_help' 或 'my_help' 触发此菜单。"
    end
    alias pkg_help='custom_help'
    alias my_help='custom_help'
    alias shelly_help='custom_help'

    if command -v eza &>/dev/null
        alias ls 'eza --icons=auto'
    end
    alias q 'qs -c ii'
end

# Fish ssh agent 设置
# 启动 ssh-agent 并设置环境变量
# 同时检查 PID 是否存活，防止重启/崩溃后 universal 变量残留
if test -z "$SSH_AGENT_PID"; or not kill -0 $SSH_AGENT_PID 2>/dev/null
    # 清理可能残留的 universal 变量
    set -e SSH_AGENT_PID
    set -e SSH_AUTH_SOCK
    eval (ssh-agent -c)
    set -Ux SSH_AGENT_PID $SSH_AGENT_PID
    set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
end

# 自动添加密钥（仅在 agent 可用时）
# -q 表示安静模式，如果密钥未加载则添加
# 你可以将 ~/.ssh/id_github 替换为你实际的密钥路径
if test -n "$SSH_AUTH_SOCK"; and not ssh-add -l &>/dev/null
    ssh-add ~/.ssh/id_github
end

# Set up fzf key bindings
fzf --fish | source
thefuck --alias | source
zoxide init fish | source

# Added by codebase-memory-mcp install
fish_add_path /home/jackwy/.local/bin
