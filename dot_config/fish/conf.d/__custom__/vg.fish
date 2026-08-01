function vg --description 'Search git tracked files and open in nvim'
    if not git rev-parse --is-inside-work-tree >/dev/null 2>&1
        echo "Not a git repository."
        return 1
    end
    set -l file (git ls-files 2>/dev/null | \
    fzf --multi --height 60% --layout=reverse --preview 'bat --color=always {} 2>/dev/null || cat {}' --preview-window=right:50%:wrap)
    if test -n "$file"
        nvim $file
    end
end
