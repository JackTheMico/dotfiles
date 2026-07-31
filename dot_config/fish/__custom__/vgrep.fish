function vgrep --description 'Ripgrep search and open nvim at line'
    # 使用 ripgrep 搜索内容，格式化为 file:line:content
    set -l result (rg --line-number --no-heading --color=never "" 2>/dev/null | \
    fzf --height 60% --layout=reverse \
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
