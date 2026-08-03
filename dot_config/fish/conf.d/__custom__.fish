# NyxNiri Custom Fish Configuration
#
# Any modifications in this file (such as aliases, exports) will be safely preserved during system updates.
# You can also create a `__custom__/` directory in the current folder to drop your private scripts in.
#
# 任何在此文件中的修改（如 alias、export）都会在系统更新时被安全保留。
# 你也可以在当前目录下创建 __custom__/ 文件夹，把自己的私有脚本都扔进去。
#
# Example / 例如：
# alias ll='ls -alF'
# set -gx EDITOR nvim

# 恢复 fish 默认 Tab 行为：覆盖 config.fish 的 custom_tab_complete 绑定
if status is-interactive
    function __restore_default_tab --on-event fish_prompt
        bind \t complete
    end
end
