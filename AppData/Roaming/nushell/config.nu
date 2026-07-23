# config.nu
#
# Installed by:
# version = "0.105.1"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# This file is loaded after env.nu and before login.nu
#
# You can open this file in your default editor using:
# config nu
#
# See `help config nu` for more options
#
# You can remove these comments if you want or leave
# them for future reference.

# zoxide
source ~/.zoxide.nu

# starship
mkdir ($nu.data-dir | path join "vendor/autoload")
^'D:\Scoop\apps\starship\current\starship.exe' init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

# proxy
# $env.http_proxy = "http://localhost:7897"
# $env.https_proxy = "http://localhost:7897"
# $env.no_proxy = "localhost,127.0.0.1"

# Key Bindings
$env.config.keybindings ++= [
  {
     name: fuzzy_file
     modifier: control
     keycode: char_t
     mode: [vi_normal, vi_insert]
     event: {
       send: executehostcommand
       cmd: "commandline edit --replace (fzf --layout=reverse)"
     }
  },
  {
    name: fuzzy_history
    modifier: control
    keycode: char_r
    mode: emacs
    event: {
      send: executehostcommand
      cmd: "commandline edit --replace (history | each { |it| $it.command } | uniq | reverse | fzf --layout=reverse --height=40% -q (commandline) | decode utf-8 | str substring 12..-50)"
    }
  },
  {
    name: change_dir_with_fzf
    modifier: control
    keycode: char_f
    mode: emacs
    event: {
      send: executehostcommand,
      cmd: "cd (ls | where type == dir | get name | str join (char newline) | fzf | decode utf-8 | str trim)"
    }
  }
]

# Starship
$env.config.shell_integration = {
  # osc2 abbreviates the path if in the home_dir, sets the tab/window title, shows the running command in the tab/window title
  osc2: true
  # osc7 is a way to communicate the path to the terminal, this is helpful for spawning new tabs in the same directory
  osc7: true
  # osc8 is also implemented as the deprecated setting ls.show_clickable_links, it shows clickable links in ls output if your terminal supports it
  osc8: true
  # osc9_9 is from ConEmu and is starting to get wider support. It's similar to osc7 in that it communicates the path to the terminal
  osc9_9: true
  # osc133 is several escapes invented by Final Term which include the supported ones below.
  # 133;A - Mark prompt start
  # 133;B - Mark prompt end
  # 133;C - Mark pre-execution
  # 133;D;exit - Mark execution finished with exit code
  # This is used to enable terminals to know where the prompt is, the command is, where the command finishes, and where the output of the command is
  osc133: false
  # osc633 is closely related to osc133 but only exists in visual studio code (vscode) and supports their shell integration features
  # 633;A - Mark prompt start
  # 633;B - Mark prompt end
  # 633;C - Mark pre-execution
  # 633;D;exit - Mark execution finished with exit code
  # 633;E - NOT IMPLEMENTED - Explicitly set the command line with an optional nonce
  # 633;P;Cwd=<path> - Mark the current working directory and communicate it to the terminal
  # and also helps with the run recent menu in vscode
  osc633: true
  # reset_application_mode is escape \x1b[?1l and was added to help ssh work better
  reset_application_mode: true
}
$env.STARSHIP_SHELL = "nu"

def create_left_prompt [] {
    starship prompt --cmd-duration $env.CMD_DURATION_MS $'--status=($env.LAST_EXIT_CODE)'
}

# Use nushell functions to define your right and left prompt
$env.PROMPT_COMMAND = { create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = ""

# The prompt indicators are environmental variables that represent
# the state of the prompt
$env.PROMPT_INDICATOR = ""
$env.PROMPT_INDICATOR_VI_INSERT = ": "
$env.PROMPT_INDICATOR_VI_NORMAL = "〉"
$env.PROMPT_MULTILINE_INDICATOR = "::: "

# Scoop search enhancement
def scoop-search-enhanced [query?: string] {
    if $query == null {
        scoop-search
    } else {
        scoop-search $query
    }
}

def rgkm [query?: string] {
  if $query == null {
    echo '必须是一个中文'
  } else {
    rg $'^($query)\t.*' ~/AppData/Roaming/Rime/kongmingma.dict.yaml | lines | reverse
  }
}

alias ss = scoop-search-enhanced
alias su = scoop update
alias sst = scoop status
alias sua = scoop update -a
alias si = scoop install
alias sui = scoop uninstall

# alias
alias czi = chezmoi
alias lg = lazygit
alias ytmp3 = yt-dlp -x -f bestaudio --audio-format mp3 

# 代理地址（可修改）
const PROXY = "http://127.0.0.1:7897"

# 启停代理的开关函数
def --env proxy-on [] {
    export-env {
        $env.http_proxy  = $PROXY
        $env.https_proxy = $PROXY
        $env.all_proxy   = $PROXY          # 可选：统一 socks/http/https
        # $env.no_proxy    = "localhost,127.0.0.1,::1"  # 可选：排除本地地址
    }
    print $"Proxy 已启用: ($PROXY)"
}

def --env proxy-off [] {
    export-env {
        $env.http_proxy  = null
        $env.https_proxy = null
        $env.all_proxy   = null
        # $env.no_proxy    = null          # 根据需要
    }
    print "Proxy 已关闭"
}

# 可选：一个 toggle 函数（根据当前状态切换）
def --env proxy-toggle [] {
    if ($env.http_proxy? | is-not-empty) and ($env.http_proxy == $PROXY) {
        proxy-off
    } else {
        proxy-on
    }
}

# Yazi
def --env y [...args] {
	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
	yazi ...$args --cwd-file $tmp
	let cwd = (open $tmp)
	if $cwd != "" and $cwd != $env.PWD {
		cd $cwd
	}
	rm -fp $tmp
}

# carapace
source ~/.cache/carapace/init.nu
source ~/AppData/Roaming/nushell/uv_completions.nu
use completions *

# >>> sivtr shell integration >>>
$env.SIVTR_TERMINAL_ID = $"($nu.pid)"
if (($env.SIVTR_PROMPT_WRAPPED? | default false) != true) {
    let _sivtr_orig_prompt_command = ($env.PROMPT_COMMAND? | default {|| "" })
    $env.SIVTR_PROMPT_CACHE = ($nu.temp-dir | path join $"sivtr_prompt_($nu.pid).txt")
    def _sivtr_render_prompt [] {
        do --ignore-errors $_sivtr_orig_prompt_command | default ""
    }
    $env.PROMPT_COMMAND = {||
        let rendered = (_sivtr_render_prompt | into string)
        do --ignore-errors { $rendered | save --force $env.SIVTR_PROMPT_CACHE }
        $rendered
    }

    def --env _sivtr_precmd [] {
        let last = (history | last 1 | get 0?)
        $env.SIVTR_COMMAND_CWD = ($env.SIVTR_NEXT_COMMAND_CWD? | default "")
        if $last != null {
            $env.SIVTR_LAST_COMMAND = ($last.command? | default "")
            $env.SIVTR_LAST_COMMAND_ID = (($last.start_timestamp? | default (date now)) | into string)
            $env.SIVTR_COMMAND_DURATION_MS = (($last.duration? | default "") | into string)
        }
        $env.SIVTR_COMMAND_ENDED_AT = (date now | into string)
        $env.SIVTR_LAST_EXIT_CODE = ($env.LAST_EXIT_CODE? | default "" | into string)
        $env.SIVTR_LAST_PROMPT = (do --ignore-errors { open --raw $env.SIVTR_PROMPT_CACHE } | default "")
        try { ^sivtr flush } catch {}
        $env.SIVTR_NEXT_COMMAND_CWD = (pwd)
    }
    $env.config.hooks.pre_prompt = ($env.config.hooks.pre_prompt? | default [] | append {|| _sivtr_precmd })
    $env.SIVTR_PROMPT_WRAPPED = true
}
# <<< sivtr shell integration <<<

