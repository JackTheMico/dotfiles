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

import os
import re
import socket
import subprocess
from libqtile import qtile
from libqtile import bar, layout, widget, hook
from libqtile.config import (
    Click,
    Drag,
    Group,
    Key,
    KeyChord,
    Match,
    Screen,
    ScratchPad,
    DropDown,
)
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
TERMINAL = guess_terminal()
MY_GROUPS = {
    "1T": "max",
    "2W": "treetab",
    "3S": "max",
    "4S": "max",
    "5O": "max",
    "6C": "treetab",
    "7H": "max",
    "8M": "max",
    "9D": "monadtall",
}
DEFAULT_SPAWNS = {
    "1T": "alacritty",
    "2W": "qutebrowser",
    "6C": ["discord-canary", "slack"],
    "+": "/opt/clash-for-windows-chinese/cfw",
}
COLORS = [
    ["#282c34", "#282c34"],
    ["#1c1f24", "#1c1f24"],
    ["#dfdfdf", "#dfdfdf"],
    ["#ff6c6b", "#ff6c6b"],
    ["#98be65", "#98be65"],
    ["#da8548", "#da8548"],
    ["#51afef", "#51afef"],
    ["#c678dd", "#c678dd"],
    ["#46d9ff", "#46d9ff"],
    ["#a9a1e1", "#a9a1e1"],
]


def is_running(process):
    s = subprocess.Popen(["ps", "axuw"], stdout=subprocess.PIPE)
    for x in s.stdout:
        if re.search(process, x.decode()):
            return True
    return False


def spawn_group(name: str, layout: str):
    if name in DEFAULT_SPAWNS.keys():
        if isinstance(DEFAULT_SPAWNS[name], str):
            if not is_running(DEFAULT_SPAWNS[name]):
                return Group(name, spawn=DEFAULT_SPAWNS[name], layout=layout)
        elif isinstance(DEFAULT_SPAWNS[name], list):
            prolist = []
            for cmd in DEFAULT_SPAWNS[name]:
                if not is_running(cmd):
                    prolist.append(cmd)
            return Group(name, spawn=prolist, layout=layout)
    return None


rofi_keychord = [
            Key([], "r", lazy.spawn("rofi -show run"), desc="Use rofi to run sth"),
            Key(
                [],
                "w",
                lazy.spawn("rofi -show window"),
                desc="Switch windows with rofi",
            ),
            Key([], "s", lazy.spawn("rofi -show ssh"), desc="SSH with rofi"),
            Key([], "d", lazy.spawn("rofi -show drun"), desc="drun with rofi"),
            Key([], "b", lazy.spawn("rofi-bluetooth"), desc="bluetooth"),
            Key([], "w", lazy.spawn("rofi-wifi-menu"), desc="wifi"),
            Key(
                [],
                "e",
                lazy.spawn("rofi -show emoji -modi emoji"),
                desc="emoji with rofi",
            ),
            Key(
                [],
                "h",
                lazy.spawn(
                    "rofi -modi 'clipboard:greenclip print' -show clipboard -run-command '{cmd}'"
                ),
                desc="rofi clipboard",
            ),
        ]

HOSTNAME = socket.gethostname()
if HOSTNAME == "jack-manajro":
    NET = "wlp1s0" 
    rofi_keychord.append(Key(
                             [],
                             "l",
                             lazy.spawn("rofi-backlight"),
                             desc="rofi backlight"
                         ))
else:
    NET = "enp2s0"

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([MOD], "h", lazy.layout.left(), desc="Move focus to left"),
    Key(
        [MOD, "shift"],
        "p",
        lazy.layout.section_up(),
        desc="Move up a section in treetab",
    ),
    Key([MOD], "l", lazy.layout.right(), desc="Move focus to right"),
    Key(
        [MOD, "shift"],
        "n",
        lazy.layout.section_down(),
        desc="Move down a section in treetab",
    ),
    Key([MOD], "j", lazy.layout.down(), desc="Move focus down"),
    Key([MOD], "k", lazy.layout.up(), desc="Move focus up"),
    Key([MOD, "shift"], "f", lazy.window.toggle_floating(), desc="toggle floating"),
    KeyChord(
        [MOD1],
        "space",
        rofi_keychord,
    ),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key(
        [MOD, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"
    ),
    Key(
        [MOD, "shift"],
        "l",
        lazy.layout.shuffle_right(),
        desc="Move window to the right",
    ),
    Key([MOD, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([MOD, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([MOD, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key(
        [MOD, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"
    ),
    Key([MOD, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([MOD, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([MOD], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    Key([MOD], "m", lazy.layout.maximize(), desc="Maximize window"),
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
    Key([MOD], "Return", lazy.spawn(TERMINAL), desc="Launch Terminal"),
    # Toggle between different layouts as defined below
    Key([MOD], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([MOD], "w", lazy.window.kill(), desc="Kill focused window"),
    Key([MOD, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([MOD, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
]


def init_groups():
    def _inner(key, name, layout):
        keys.append(Key([MOD], key, lazy.group[name].toscreen()))
        keys.append(Key([MOD, "shift"], key, lazy.window.togroup(name)))
        group = spawn_group(name, layout)
        if not group:
            group = Group(name, layout=layout)
        return group

    # groups = [("dead_grave", "00")]
    groups = [
        (str(index), i[0], i[-1]) for index, i in zip(range(1, 10), MY_GROUPS.items())
    ]
    # groups += [("0", "10"), ("minus", "11"), ("equal", "12")]
    groups += [
        ("0", "0D", "monadtall"),
        ("minus", "-", "floating"),
        ("equal", "+", "ratiotile"),
    ]
    res_groups = [_inner(*i) for i in groups]
    res_groups += [
        ScratchPad(
            "scratchpad",
            [DropDown("zsh", TERMINAL, x=0.0 ,height=0.5, width=1.0, opacity=0.6)],
        )
    ]
    keys.append(Key([], "Pause", lazy.group["scratchpad"].dropdown_toggle("zsh")))
    return res_groups


groups = init_groups()

LAYOUT_THEME = {
    "border_width": 2,
    "margin": 8,
    "border_focus": "e1acff",
    "border_normal": "1D2330",
}
layouts = [
    layout.Max(**LAYOUT_THEME),
    layout.Columns(border_focus_stack=["#d75f5f", "#8f3d3d"], border_width=4),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=3),
    layout.Bsp(**LAYOUT_THEME),
    layout.Matrix(**LAYOUT_THEME),
    layout.MonadTall(**LAYOUT_THEME),
    layout.MonadWide(**LAYOUT_THEME),
    layout.RatioTile(**LAYOUT_THEME),
    layout.Tile(**LAYOUT_THEME),
    layout.TreeTab(
        font="Ubuntu",
        fontsize=12,
        sections=["FIRST", "SECOND", "THIRD", "FOURTH"],
        section_fontsize=12,
        border_width=2,
        bg_color="1c1f24",
        active_bg="c678dd",
        active_fg="000000",
        inactive_bg="a9a1e1",
        inactive_fg="1c1f24",
        padding_left=0,
        padding_x=0,
        padding_y=5,
        section_top=10,
        section_bottom=20,
        level_shift=8,
        vspace=3,
        panel_width=200,
    ),
    layout.Floating(**LAYOUT_THEME),
    layout.VerticalTile(**LAYOUT_THEME),
    # layout.Zoomy(),
]

widget_defaults = dict(font="Ubuntu Bold", fontsize=12, padding=2, background=COLORS[2])
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.Sep(
                    linewidth=0, padding=6, foreground=COLORS[2], background=COLORS[0]
                ),
                widget.Image(
                    filename="~/.config/qtile/icons/python-white.png",
                    scale="False",
                    mouse_callbacks={"Button1": lambda: qtile.cmd_spawn(TERMINAL)},
                ),
                widget.Sep(
                    linewidth=0, padding=6, foreground=COLORS[2], background=COLORS[0]
                ),
                widget.GroupBox(
                    font="Hack Nerd Bold",
                    fontsize=12,
                    margin_y=3,
                    margin_x=0,
                    padding_y=5,
                    padding_x=3,
                    borderwidth=3,
                    active=COLORS[2],
                    inactive=COLORS[7],
                    rounded=False,
                    highlight_color=COLORS[1],
                    highlight_method="line",
                    this_current_screen_border=COLORS[6],
                    this_screen_border=COLORS[4],
                    other_current_screen_border=COLORS[6],
                    other_screen_border=COLORS[4],
                    foreground=COLORS[2],
                    background=COLORS[0],
                ),
                widget.TextBox(
                    text="|",
                    font="Hack Nerd Bold",
                    background=COLORS[0],
                    foreground="474747",
                    padding=2,
                    fontsize=14,
                ),
                widget.CurrentLayoutIcon(
                    custom_icon_paths=[os.path.expanduser("~/.config/qtile/icons")],
                    foreground=COLORS[2],
                    background=COLORS[0],
                    padding=0,
                    scale=0.7,
                ),
                widget.CurrentLayout(
                    foreground=COLORS[2],
                    background=COLORS[0],
                    padding=5,
                    font="Hack Nerd Bold",
                    fontsize=14,
                ),
                widget.TextBox(
                    text="|",
                    font="Hack Nerd Bold",
                    background=COLORS[0],
                    foreground="474747",
                    padding=2,
                    fontsize=14,
                ),
                widget.WindowName(
                    foreground=COLORS[6],
                    background=COLORS[0],
                    padding=0,
                    font="Hack Nerd Bold",
                    fontsize=14,
                    format="{name}",
                ),
                widget.Systray(background=COLORS[0], padding=5),
                widget.Pomodoro(
                    font="Hack Nerd Bold",
                    fontsize=12,
                    padding=5,
                    foreground=COLORS[1],
                    background=COLORS[9],
                ),
                widget.Sep(
                    linewidth=0, padding=6, foreground=COLORS[0], background=COLORS[0]
                ),
                widget.Volume(
                    font="Ubuntu Mono",
                    background=COLORS[1],
                    foreground=COLORS[3],
                    fontsize=37,
                    padding=0,
                    emoji=True
                ),
                widget.WidgetBox(
                    font="Ubuntu Mono",
                    background=COLORS[1],
                    foreground=COLORS[3],
                    fontsize=37,
                    padding=0,
                    widgets=[
                widget.TextBox(
                    text="",
                    font="Ubuntu Mono",
                    background=COLORS[0],
                    foreground=COLORS[3],
                    padding=0,
                    fontsize=37,
                ),
                widget.Net(
                    interface=NET,
                    format="Net: {down} ↓↑ {up}",
                    foreground=COLORS[1],
                    background=COLORS[3],
                    padding=5,
                ),
                widget.TextBox(
                    text="",
                    font="Ubuntu Mono",
                    background=COLORS[3],
                    foreground=COLORS[4],
                    padding=0,
                    fontsize=37,
                ),
                widget.ThermalSensor(
                    foreground=COLORS[1],
                    background=COLORS[4],
                    threshold=90,
                    fmt="Temp: {}",
                    padding=5,
                ),
                widget.TextBox(
                    text="",
                    font="Ubuntu Mono",
                    background=COLORS[4],
                    foreground=COLORS[5],
                    padding=0,
                    fontsize=37,
                ),
                widget.CheckUpdates(
                    update_interval=1800,
                    distro="Arch_checkupdates",
                    display_format="Updates: {updates} ",
                    foreground=COLORS[1],
                    colour_have_updates=COLORS[1],
                    colour_no_updates=COLORS[1],
                    mouse_callbacks={
                        "Button1": lambda: qtile.cmd_spawn(TERMINAL + " -e sudo paru")
                    },
                    padding=5,
                    background=COLORS[5],
                ),
                widget.TextBox(
                    text="",
                    font="Ubuntu Mono",
                    background=COLORS[5],
                    foreground=COLORS[6],
                    padding=0,
                    fontsize=37,
                ),
                widget.Memory(
                    foreground=COLORS[1],
                    background=COLORS[6],
                    mouse_callbacks={
                        "Button1": lambda: qtile.cmd_spawn(TERMINAL + " -e htop")
                    },
                    fmt="Mem: {}",
                    padding=5,
                )
                ]),
                widget.TextBox(
                    text="",
                    font="Ubuntu Mono",
                    background=COLORS[7],
                    foreground=COLORS[8],
                    padding=0,
                    fontsize=37,
                ),
                widget.Wallpaper(
                    directory="/home/dlwxxxdlw/Pictures/wallpapers",
                    random_selection=True,
                    wallpaper_command=["feh", "--bg-max"],
                    padding=5,
                    foreground=COLORS[1],
                    background=COLORS[8],
                    label="😻",
                ),
                widget.TextBox(
                    text="",
                    font="Ubuntu Mono",
                    background=COLORS[8],
                    foreground=COLORS[9],
                    padding=0,
                    fontsize=37,
                ),
                widget.Clock(
                    foreground=COLORS[1],
                    background=COLORS[9],
                    format="%A, %B %d - %H:%M ",
                    padding=5,
                ),
                widget.QuickExit(
                    default_text="🏃",
                    background=COLORS[1],
                    foreground=COLORS[9],
                    padding=0,
                ),
            ],
            20,
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag(
        [MOD],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [MOD], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
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


@hook.subscribe.startup_once
def start_once():
    home = os.path.expanduser("~")
    subprocess.call([home + "/.config/qtile/autostart.sh"])


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
