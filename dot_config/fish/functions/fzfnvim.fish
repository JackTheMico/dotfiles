# 1. vf: 模糊搜索当前目录及子目录下的所有文件，并用 nvim 打开
function vf --description 'Search files and open in nvim'
    set -l file (fd --type f --hidden --exclude .git 2>/dev/null | \
    fzf --height 40% --layout=reverse --preview 'bat --color=always {} 2>/dev/null || cat {}' --preview-window=right:50%:wrap)
    if test -n "$file"
        nvim $file
    end
end

# 2. vg: 模糊搜索 Git 仓库内追踪的文件，并用 nvim 打开
function vg --description 'Search git tracked files and open in nvim'
    if not git rev-parse --is-inside-work-tree >/dev/null 2>&1
        echo "Not a git repository."
        return 1
    end
    set -l file (git ls-files 2>/dev/null | \
    fzf --height 40% --layout=reverse --preview 'bat --color=always {} 2>/dev/null || cat {}' --preview-window=right:50%:wrap)
    if test -n "$file"
        nvim $file
    end
end

# 3. vgrep: 模糊搜索文件内容，并用 nvim 定位到指定文件的指定行
function vgrep --description 'Ripgrep search and open nvim at line'
    # 使用 ripgrep 搜索内容，格式化为 file:line:content
    set -l result (rg --line-number --no-heading --color=never "" 2>/dev/null | \
    fzf --height 40% --layout=reverse \
        --delimiter ':' \
        --preview 'bat --color=always --highlight-line {2} {1} 2>/dev/null || cat {1}' \
        --preview-window=right:60%:wrap)

    if test -n "$result"
        # 提取文件名和行号
        set -l parts (string split ":" $result)
        set -l filename $parts[1]
        set -l linenumber $parts[2]

        # 以 +行号 的形式打开 nvim，例如 nvim +12 file.txt
        nvim +$linenumber $filename
    end
end

# 4. vrc: 快速模糊查找并编辑 Neovim 配置文件
function vrc --description 'Search and edit neovim config files'
    set -l config_dir "$HOME/.config/nvim"
    if test ! -d $config_dir
        echo "Neovim config directory not found at $config_dir"
        return 1
    end
    set -l file (fd . --type f --hidden $config_dir 2>/dev/null | \
    fzf --height 40% --layout=reverse --preview 'bat --color=always {} 2>/dev/null || cat {}' --preview-window=right:50%:wrap)
    if test -n "$file"
        nvim $file
    end
end
