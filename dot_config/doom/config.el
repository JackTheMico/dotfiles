;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!
(setq shell-file-name (executable-find "bash"))

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Jack Wenyoung"
      user-mail-address "dlwxxxdlw@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "Maple Mono NF CN" :size 23 :weight 'Medium)
      doom-variable-pitch-font (font-spec :family "LXGW WenKai Screen" :size 21)
      doom-big-font (font-spec :family "Maple Mono NF CN" :size 36)
      doom-symbol-font (font-spec :family "Maple Mono NF CN")
      doom-serif-font (font-spec :family "Noto Serif CJK SC")
      nerd-icons-font-family "JetBrainsMono Nerd Font Mono")

;; 中文回退：代码中的汉字也用霞鹜文楷（Maple 自带汉字，需覆盖 fontset）
(after! (doom-ui)
  (set-fontset-font t 'han (font-spec :family "LXGW WenKai Mono Screen"))
  (set-fontset-font t 'cjk-misc (font-spec :family "LXGW WenKai Mono Screen")))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-dracula)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type :relative)

;; org 目录结构（GTD 任务区 + org-roam 知识库分离）：
;;   ~/org/gtd/    — Org Agenda 任务管理区：inbox.org / projects.org /
;;                   tickler.org / calendar.org
;;   ~/org/roam/   — org-roam 知识库区：index.org 及
;;                   quant / tcm / metaphysics / writing / tech 子目录
;; org-directory 必须在 org 加载前设置。org 是懒加载的，顶层 setq 时 org
;; 尚未加载，下面的 defcustom 同理安全；它们会覆盖 Doom 模块的默认值。
(setq org-directory "~/org/"
      ;; Agenda 只扫 gtd 区（Doom 默认扫整个 ~/org，会把 roam 知识库也卷进 agenda）
      org-agenda-files '("~/org/gtd/")
      ;; capture 的兜底文件（Doom "n" 笔记模板等使用）
      org-default-notes-file "~/org/gtd/inbox.org"
      ;; org-roam 知识库根（+roam 已启用；不设的话默认是 ~/org-roam）
      org-roam-directory "~/org/roam/")
;; Doom 默认 capture 模板的目标改到 gtd 收集箱（默认是 {org-directory}/todo.org）：
;; "t"（Personal todo）和 "n"（Personal notes）都先进 inbox.org，
;; 符合 GTD "先收集、后分类" 流程。+org-capture-* 是 Doom org 模块的变量，
;; 模块先于本文件加载，此处 setq 生效于模块默认值之后。
(setq +org-capture-todo-file "gtd/inbox.org"
      +org-capture-notes-file "gtd/inbox.org")
;; org 里 RET 的 dwim：
;;   normal/motion 状态 + 光标在链接上  → 打开链接（org-roam 的 node 跳转）
;;   normal/motion 状态 + 光标在 headline → 展开/折叠该节点
;;   insert 状态 / 其他位置              → 原 org-return（换行、插入新行）
;; 原理：meow normal state 没绑 RET，原本穿透到 org-return；而 org 默认
;; `org-return-follows-link' 为 nil，RET 在链接上不跟随（得用 C-c C-o）。
;; 这里手动接管链接跟随，且只在 normal/motion 下生效，避免 insert 编辑
;; 链接文本时按 RET 误触跳转。org-roam 的 [[id:...][标题]] 由 org-id 解析，
;; org-open-at-point 即可跳转到对应 note。
(after! org
  (defun +org-ret-cycle-or-return ()
    "RET dwim in org-mode:
- open the link at point (org-roam node jump);
- on a heading, open the first link in that heading line, else cycle it;
- otherwise behave like `org-return'."
    (interactive)
    (cond
     ;; insert 状态：永远换行/插入，不跳转
     ((bound-and-true-p meow-insert-mode) (org-return))
     ;; 光标在链接上：打开链接（org-roam 跳转）
     ((org-in-regexp org-link-any-re) (org-open-at-point))
     ;; headline：heading 行内有链接则直接打开（org-roam 的
     ;; `* [[id:...][标题]]' 就是这种情况），否则展开/折叠。
     ;; 用 org-link-open-from-string 绕开 org-open-at-point 在
     ;; headline 上"列出 entry 内链接"的选择菜单，实现一键跳转。
     ((org-at-heading-p)
      (save-excursion
        (goto-char (line-beginning-position))
        (if (re-search-forward org-link-any-re (line-end-position) t)
            (org-link-open-from-string (match-string-no-properties 0))
          (org-cycle))))
     (t (org-return))))
  (map! :map org-mode-map "RET" #'+org-ret-cycle-or-return))
;; 开启 Org-roam 数据库自动同步
(org-roam-db-autosync-mode)
;; 可选：在保存文件时自动更新数据库
(add-hook 'org-mode-hook #'org-roam-db-autosync-enable)


;; jk 退出 insert 模式 (vim 风格)
(after! meow
  (setq meow-cursor-type-normal 'box
        meow-cursor-type-insert 'box
        meow-cursor-type-beacon 'box
        meow-cursor-type-default 'box)
  (defun +meow/insert-escape ()
    "在 INSERT 状态下输入 `jk' 时退出到 NORMAL 状态."
    (interactive)
    (if (and (eq last-command-event ?k)
             (eq (char-before) ?j))
        (progn
          (delete-backward-char 1)
          (meow-normal-mode))
      (self-insert-command 1)))
  (meow-define-keys 'insert
    '("j" . +meow/insert-escape)
    '("k" . +meow/insert-escape)))


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; buffer 操作：meow 的 SPC 映射到 doom-leader-map，因此 <leader> b 即 SPC b
;; （evil 版默认有 <leader> b，meow 走的 +emacs-bindings 没有，这里补上）
(map! :leader
      (:prefix-map ("b" . "buffer")
       :desc "Switch buffer"                 "b" #'consult-buffer
       :desc "Switch workspace buffer"       "B" #'persp-switch-to-buffer
       :desc "Clone buffer"                  "c" #'clone-indirect-buffer
       :desc "Clone buffer other window"     "C" #'clone-indirect-buffer-other-window
       :desc "Kill buffer"                   "d" #'kill-current-buffer
       :desc "ibuffer"                       "i" #'ibuffer
       :desc "Kill buffer"                   "k" #'kill-current-buffer
       :desc "Kill all buffers"              "K" #'doom/kill-all-buffers
       :desc "New empty buffer"              "N" #'+default/new-buffer
       :desc "Next buffer"                   "n" #'next-buffer
       :desc "Kill other buffers"            "O" #'doom/kill-other-buffers
       :desc "Previous buffer"               "p" #'previous-buffer
       :desc "Revert buffer"                 "r" #'revert-buffer
       :desc "Rename buffer"                 "R" #'rename-buffer
       :desc "Save buffer"                   "s" #'basic-save-buffer
       :desc "Save all buffers"              "S" #'save-some-buffers
       :desc "Save buffer as root"           "u" #'doom/sudo-save-buffer
       :desc "Pop up scratch buffer"         "x" #'doom/open-scratch-buffer
       :desc "Switch to scratch buffer"      "X" #'doom/switch-to-scratch-buffer
       :desc "Yank buffer"                   "y" #'+default/yank-buffer-contents
       :desc "Bury buffer"                   "z" #'bury-buffer
       :desc "Kill buried buffers"           "Z" #'doom/kill-buried-buffers))

;; window 操作：SPC w 重构为纯 window 前缀（对齐 lazyvim/spacemacs）
;; 原 SPC w 里的 workspace 操作移到 SPC TAB（与 Doom evil 版惯例一致）
(define-key doom-leader-map "w" nil) ; 清掉默认的 workspaces/windows 前缀
(map! :leader
      (:prefix-map ("w" . "window")
       :desc "Split below"                "-" #'split-window-below
       :desc "Split right"                "/" #'split-window-right
       :desc "Split below"                "s" #'split-window-below
       :desc "Split right"                "v" #'split-window-right
       :desc "Delete window"              "c" #'delete-window
       :desc "Delete window"              "d" #'delete-window
       :desc "Delete window"              "x" #'delete-window
       :desc "Delete other windows"       "o" #'delete-other-windows
       :desc "Delete other windows"       "1" #'delete-other-windows
       :desc "Balance windows"            "=" #'balance-windows
       :desc "Maximize buffer"            "m" #'doom/window-maximize-buffer
       :desc "Enlargen window"            "M" #'doom/window-enlargen
       :desc "Focus window left"          "h" #'windmove-left
       :desc "Focus window down"          "j" #'windmove-down
       :desc "Focus window up"            "k" #'windmove-up
       :desc "Focus window right"         "l" #'windmove-right
       :desc "Move window left"           "H" #'windmove-swap-states-left
       :desc "Move window down"           "J" #'windmove-swap-states-down
       :desc "Move window up"             "K" #'windmove-swap-states-up
       :desc "Move window right"          "L" #'windmove-swap-states-right
       :desc "Other window"               "w" #'other-window
       :desc "Focus other window"         "." #'other-window
       :desc "Undo window config"         "u" #'winner-undo
       :desc "Redo window config"         "U" #'winner-redo)
      ;; workspace 移到 SPC TAB（Doom evil 版布局）
      (:prefix-map ("TAB" . "workspace")
       :desc "Display workspace tabs"     "TAB" #'+workspace/display
       :desc "Switch workspace"           "."   #'+workspace/switch-to
       :desc "Switch to last workspace"   "`"   #'+workspace/other
       :desc "New workspace"              "n"   #'+workspace/new
       :desc "New named workspace"        "N"   #'+workspace/new-named
       :desc "Load workspace from file"   "l"   #'+workspace/load
       :desc "Save workspace to file"     "s"   #'+workspace/save
       :desc "Kill session"               "x"   #'+workspace/kill-session
       :desc "Kill this workspace"        "d"   #'+workspace/kill
       :desc "Delete saved workspace"     "D"   #'+workspace/delete
       :desc "Rename workspace"           "r"   #'+workspace/rename
       :desc "Restore last session"       "R"   #'+workspace/restore-last-session
       :desc "Next workspace"             "]"   #'+workspace/switch-right
       :desc "Previous workspace"         "["   #'+workspace/switch-left
       :desc "Switch to workspace 1"      "1"   #'+workspace/switch-to-0
       :desc "Switch to workspace 2"      "2"   #'+workspace/switch-to-1
       :desc "Switch to workspace 3"      "3"   #'+workspace/switch-to-2
       :desc "Switch to workspace 4"      "4"   #'+workspace/switch-to-3
       :desc "Switch to workspace 5"      "5"   #'+workspace/switch-to-4
       :desc "Switch to workspace 6"      "6"   #'+workspace/switch-to-5
       :desc "Switch to workspace 7"      "7"   #'+workspace/switch-to-6
       :desc "Switch to workspace 8"      "8"   #'+workspace/switch-to-7
       :desc "Switch to workspace 9"      "9"   #'+workspace/switch-to-8
       :desc "Switch to last workspace"   "0"   #'+workspace/switch-to-final))

;; ghostel 终端 (dakra/ghostel fuller example)
(map! :leader "RET" #'ghostel)
;; ghostel-project 加入 SPC p 前缀。
;; 注意1：ghostel 是懒加载，若放在 use-package! 的 :config 里，只有首次打开
;;   ghostel 后绑定才会出现；放顶层 + autoload 命令则始终可见。
;; 注意2：:prefix 必须用纯字符串 "p"（不带 desc）。带 desc 的
;;   (:prefix ("p" . "project")) 会按 map! 文档 WARNING 清空 p 前缀
;;   上 +emacs-bindings 已有的绑定（. s x X F 等）。
;; 注意3：不能用小写 "m" —— meow Keypad 把 ?m 保留作 meta 修饰前缀
;;   （meow-keypad-meta-prefix），SPC 菜单里的 m 会被拦截且不显示。
;;   故 ghostel-project 用 "t"（terminal），list-buffers 用 "M"。
(map! :leader
      (:prefix "p"
       :desc "Ghostel project"          "t" #'ghostel-project
       :desc "Ghostel project buffers"  "M" #'ghostel-project-list-buffers))
(use-package! ghostel
  :config
  ;; semi-char 模式下 C-s/C-k/M-p/M-n 默认被发给终端；加入
  ;; ghostel-keymap-exceptions 让它们 pass through 给 Emacs。
  ;; setopt 走 custom :set → 触发 ghostel--rebuild-semi-char-keymap 重建 keymap，
  ;; 所以下面的键绑定必须放在重建之后（即这里）。
  (setopt ghostel-keymap-exceptions
          (cl-union '("C-s" "C-k" "M-p" "M-n")
                    ghostel-keymap-exceptions :test #'equal))
  (map! :map ghostel-semi-char-mode-map
        "C-s" #'consult-line
        ;; C-k: 关闭当前 ghostel 终端（ghostel 没有专用 close 命令，kill-buffer 即关闭）
        "C-k" #'kill-current-buffer
        "M-p" (lambda () (interactive) (ghostel-send-key "p" "ctrl"))
        "M-n" (lambda () (interactive) (ghostel-send-key "n" "ctrl")))
  ;; ghostel 里允许 eval 的 Emacs 命令（C-c 前缀）
  (add-to-list 'ghostel-eval-cmds '("magit-status-setup-buffer" magit-status-setup-buffer))
  ;; M-x project-switch-project 的项目切换菜单加入 Ghostel 条目
  ;; （project-switch-commands 是内置 project.el 的变量，需等其加载）
  (with-eval-after-load 'project
    (add-to-list 'project-switch-commands '(ghostel-project "Ghostel") t)
    (add-to-list 'project-switch-commands '(ghostel-project-list-buffers "Ghostel buffers") t)))

;;; dirvish 文件管理器（dired 增强，键位参考 yazi）
;; meow 对 dired 等特殊 mode 默认用 MOTION state；其 keymap 只占用了
;; [escape] 和 SPC 两个键，其余单键都会落到 dirvish-mode-map，
;; 因此下面的绑定在 dirvish 里全部生效（唯一例外：SPC 是 meow keypad，
;; 所以标记用 dired 默认的 m，空格无法用作 yazi 的选中）。
(use-package! dirvish
  :custom
  ;; defcustom，必须走 custom 路径（:custom / setopt）才会触发 transient
  ;; 菜单重建；setq 无效
  (dirvish-quick-access-entries
   '(("h" "~/"                          "Home")
     ("d" "~/Downloads/"                "Downloads")
     ("o" "~/org/"                      "Org")
     ("c" "~/.config/"                  "Config")
     ("t" "~/.local/share/Trash/files/" "Trash")
     ("e" "/sudo:root@localhost:/etc"   "System")
     ("w" "~/codes/" "Work"))
   )
  :config
  (setq dirvish-mode-line-format
        '(:left (sort symlink) :right (omit yank index)))
  (setq dirvish-attributes
        '(vc-state subtree-state nerd-icons collapse git-msg file-time file-size)
        dirvish-side-attributes
        '(vc-state nerd-icons collapse file-size)
        dirvish-large-directory-threshold 20000)
  :bind
  (:map dirvish-mode-map
        ;; --- yazi 风格导航 ---
        ("j"   . dired-next-line)       ; 下移（dired 默认 j 是 goto-file）
        ("k"   . dired-previous-line)   ; 上移（默认 k 是 kill-lines）
        ("h"   . dired-up-directory)    ; 上级目录
        ("l"   . dired-find-file)       ; 进入 / 打开（默认 l 是 redisplay）
        ("G"   . end-of-buffer)         ; 跳到底部
        ;; --- yazi 风格文件操作 ---
        ("y"   . dirvish-yank-menu)     ; 粘贴/移动菜单（标记源后到目标目录按 y/p）
        ("p"   . dirvish-yank-menu)     ; yazi 的 p = paste
        ("x"   . dired-do-rename)       ; 剪切 = 移动（默认 x 是执行删除）
        ("d"   . dired-do-delete)       ; 删除（走系统回收站，见下）
        ("a"   . dired-create-directory) ; 新建目录
        ("r"   . dired-do-rename)       ; 重命名 / 移动
        ;; --- 过滤与显示 ---
        ("/"   . dirvish-narrow)        ; 过滤列表（yazi 的 /）
        ("N"   . dirvish-narrow)
        ("."   . dired-omit-mode)       ; 切换隐藏文件
        ;; --- dirvish 增强（官方 sample config） ---
        (";"   . dired-up-directory)
        ("?"   . dirvish-dispatch)      ; [??] 快捷键速查表
        ("o"   . dirvish-quick-access)  ; [o] 快速访问（上面的 entries）
        ("s"   . dirvish-quicksort)     ; [s] 排序
        ("v"   . dirvish-vc-menu)       ; [v] git 操作
        ("f"   . dirvish-file-info-menu) ; [f] 文件信息
        ("*"   . dirvish-mark-menu)
        ("^"   . dirvish-history-last)  ; 最近访问
        ("TAB" . dirvish-subtree-toggle) ; 展开/折叠子树
        ("M-f" . dirvish-history-go-forward)
        ("M-b" . dirvish-history-go-backward)
        ("M-e" . dirvish-emerge-menu)))

;; 删除走系统回收站（配合 quick-access 里的 Trash 入口）
(setq delete-by-moving-to-trash t)

;; 隐藏文件：dired-omit-mode 默认隐藏所有 dotfile（dired-x 内置）
(use-package! dired-x
  :config
  (setq dired-omit-files
        (concat dired-omit-files "\\|^\\..*$")))
