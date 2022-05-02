# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import re
import subprocess
from libqtile import bar, layout, widget, hook
from libqtile.config import Click, Drag, Group, Key, KeyChord, Match, Screen, ScratchPad, DropDown
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal


GREY = "#444444"
DARK_GREY = "#333333"
BLUE = "#007fcf"
DARK_BLUE = "#005083"
ORANGE = "#dd6600"
DARK_ORANGE = "#582c00"
MOD1 = "mod1"
MOD = "mod4"
terminal = guess_terminal()
default_spawn = {
    "01": "alacritty",
    "02": "qutebrowser",
    "12": "/opt/clash-for-windows-chinese/cfw"
}


def is_running(process):
    s = subprocess.Popen(["ps", "axuw"], stdout=subprocess.PIPE)
    for x in s.stdout:
        if re.search(process, x.decode()):
            return True
    return False


def spawn_group(name:str):
    if not is_running(name):
        return Group(name, spawn=name)


def execute(process):
    """
    execute a application once
    :Keyword Arguments:
     process -- application name
    :return: None
    """
    result = subprocess.Popen(process.split(), stdout=subprocess.PIPE)
    if result.stdout:
        std = result.stdout.read()
        if std:
            return std.decode().strip()


@hook.subscribe.startup_once
def startup():
    """
    start the applications when qtile startup
    :return: None
    """
    execute("fcitx5 &")
    pass 

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([MOD], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([MOD], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([MOD], "j", lazy.layout.down(), desc="Move focus down"),
    Key([MOD], "k", lazy.layout.up(), desc="Move focus up"),
    # Key([MOD1], "space", lazy.spawn("rofi -show run"), desc="Use rofi to run sth"),
    # Key([MOD1], "Return", lazy.spawn("rofi -show window"), desc="Switch windows with rofi"),
    # Key([MOD1], "s", lazy.spawn("rofi -show ssh"), desc="SSH with rofi"),
    # Key([MOD1], "e", lazy.spawn("rofi -show emoji -modi emoji"), desc="emoji with rofi"),
    Key([MOD1], "h", lazy.spawn("rofi -modi 'clipboard:greenclip print' -show clipboard -run-command '{cmd}'"), desc="rofi clipboard"),
    KeyChord([MOD1], "space", [
                Key([], "r", lazy.spawn("rofi -show run"), desc="Use rofi to run sth"),
                Key([], "w", lazy.spawn("rofi -show window"), desc="Switch windows with rofi"),
                Key([], "s", lazy.spawn("rofi -show ssh"), desc="SSH with rofi"),
                Key([], "e", lazy.spawn("rofi -show emoji -modi emoji"), desc="emoji with rofi"),
                Key([], "h", lazy.spawn("rofi -modi 'clipboard:greenclip print' -show clipboard -run-command '{cmd}'"), desc="rofi clipboard"),
             ]),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([MOD, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([MOD, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([MOD, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([MOD, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([MOD, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([MOD, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([MOD, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([MOD, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([MOD], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [MOD, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([MOD], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([MOD], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([MOD], "w", lazy.window.kill(), desc="Kill focused window"),
    Key([MOD, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([MOD, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([MOD], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
]


def init_groups():
    def _inner(key, name):
        keys.append(Key([MOD], key, lazy.group[name].toscreen()))
        keys.append(Key([MOD, "shift"], key, lazy.window.togroup(name)))
        spawn_group(name) 
        return Group(name)

    # groups = [("dead_grave", "00")]
    groups = [(str(i), "0" + str(i)) for i in range(1, 10)]
    groups += [("0", "10"), ("minus", "11"), ("equal", "12")]
    res_groups = [_inner(*i) for i in groups]
    res_groups += [
        ScratchPad("scratchpad",
                   [DropDown("zsh", terminal, height=0.5, opacity=0.6)])
    ]
    keys.append(
        Key([], 'Pause', lazy.group['scratchpad'].dropdown_toggle('zsh')))
    return res_groups

groups = init_groups() 

# for i in groups:
#     keys.extend(
#         [
#             # mod1 + letter of group = switch to group
#             Key(
#                 [MOD],
#                 i.name,
#                 lazy.group[i.name].toscreen(),
#                 desc="Switch to group {}".format(i.name),
#             ),
#             # mod1 + shift + letter of group = switch to & move focused window to group
#             Key(
#                 [MOD, "shift"],
#                 i.name,
#                 lazy.window.togroup(i.name, switch_group=True),
#                 desc="Switch to & move focused window to group {}".format(i.name),
#             ),
#             # Or, use below if you prefer not to switch to that group.
#             # # mod1 + shift + letter of group = move focused window to group
#             # Key([MOD, "shift"], i.name, lazy.window.togroup(i.name),
#             #     desc="move focused window to group {}".format(i.name)),
#         ]
#     )

layouts = [
    layout.Max(),
    layout.Columns(border_focus_stack=["#d75f5f", "#8f3d3d"], border_width=4),
    # Try more layouts by unleashing below layouts.
    layout.Stack(num_stacks=3),
    layout.Bsp(),
    layout.Matrix(),
    layout.MonadTall(),
    layout.MonadWide(),
    layout.RatioTile(),
    layout.Tile(),
    layout.TreeTab(),
    layout.VerticalTile(),
    layout.Zoomy(),
]

widget_defaults = dict(
    font="FiraCode",
    fontsize=12,
    padding=3,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.CurrentLayout(),
                widget.CurrentLayoutIcon(scale=0.6, padding=-4),
                widget.GroupBox(),
                widget.Prompt(),
                widget.WindowName(),
                widget.Wallpaper(
                    directory="/home/dlwxxxdlw/Pictures/wallpapers",
                    random_selection=True,
                    wallpaper_command=['feh', '--bg-max']
                ),
                # widget.Chord(
                #     chords_colors={
                #         "launch": ("#ff0000", "#ffffff"),
                #     },
                #     name_transform=lambda name: name.upper(),
                # ),
                # widget.TextBox("Press &lt;M-r&gt; to spawn", foreground="#d75f5f"),
                widget.Systray(),
                widget.Clock(format="%Y-%m-%d %a %I:%M %p"),
                widget.QuickExit(),
            ],
            24,
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
        ),
       bottom=bar.Bar(
            [
                # widget.Notify(),
                widget.Cmus(),
                widget.GmailChecker(username="jack@fireworkhq.com",
                                    # password="rhrazpkbgytmpfyk",
                                    password=execute_once("lpass show himalaya-jack --password"),
                                    ),
                widget.Pomodoro(),
            ],
            20
        ) 
    ),
]

# Drag floating layouts.
mouse = [
    Drag([MOD], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([MOD], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([MOD], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True



# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
