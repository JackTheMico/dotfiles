# yazi
function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    command yazi $argv --cwd-file="$tmp"
    if read -z cwd <"$tmp"; and [ "$cwd" != "$PWD" ]; and test -d "$cwd"
        builtin cd -- "$cwd"
    end
    command rm -f -- "$tmp"
end

# Path
fish_add_path ~/.config/emacs/bin/

# My alias
alias refish='source ~/.config/fish/config.fish'
alias efish='nvim ~/.config/fish/conf.d/__custom__/jackwy.fish'
alias ekmd='nvim ~/.local/share/fcitx5/rime/kongmingma.dict.yaml'
alias ekms='nvim ~/.local/share/fcitx5/rime/kongmingma.schema.yaml'
alias czi=chezmoi
alias pu=paruse
alias lg=lazygit
alias md=mkdir
alias ff=fastfetch

# sudoedit
set -gx SUDO_EDITOR nvim
set -gx EDITOR nvim
set -gx BROWSER qutebrowser
set -gx WQ_BRAIN_USERNAME dlwxxxdlw@gmail.com
set -gx WQ_BRAIN_PASSWORD DLW@winlot089

# yt-dlp music
function ytbi
    yt-dlp -x --audio-format mp3 --audio-quality 0 --embed-thumbnail --add-metadata --cookies-from-browser firefox $argv
end

# Fish ssh agent 设置
# 启动 ssh-agent 并设置环境变量
# 同时检查 socket 文件与 PID 是否存活，防止重启/崩溃后 universal 变量残留
# 注意：只检查 PID 不够——agent 进程虽在但 socket 文件丢失时（如 /tmp 清理、agent 重启），
# ssh-add 会报 "Error connecting to agent: No such file or directory"
if test -z "$SSH_AGENT_PID"; or test -z "$SSH_AUTH_SOCK"; or not test -S "$SSH_AUTH_SOCK"; or not kill -0 $SSH_AGENT_PID 2>/dev/null
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
if test -n "$SSH_AUTH_SOCK"; and test -S "$SSH_AUTH_SOCK"; and not ssh-add -l &>/dev/null
    ssh-add $HOME/.ssh/id_github 2>/dev/null
end

# Set up fzf key bindings
fzf --fish | source
thefuck --alias | source
zoxide init fish | source
