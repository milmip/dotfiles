#!/usr/bin/env python3
# ~/.config/i3/wallpaper_daemon.py

import i3ipc

WALLPAPERS = {
    "1": "/home/skip/.config/background/youvecomethisfar_1.png",
    "2": "/home/skip/.config/background/youvecomethisfar_2.png",
    "3": "/home/skip/.config/background/youvecomethisfar_3.png",
}
DEFAULT = "/home/skip/.config/background/youvecomethisfar_1.png"

def on_workspace_focus(i3, event):
    ws_name = event.current.name
    wp = WALLPAPERS.get(ws_name, DEFAULT)
    import subprocess
    subprocess.run(["feh", "--bg-scale", wp])

i3 = i3ipc.Connection()
i3.on("workspace::focus", on_workspace_focus)
i3.main()
