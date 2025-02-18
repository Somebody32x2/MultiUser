# MultiUser
A tool to allow multiple keyboards to allow two programmers to develop simultaneously on the same computer.

Each developer uses a separate keyboard, ide, and optionally browser.

Switch to your browser by pressing `Ctrl + Shift + "` (the `'`/`"` key) by default - configure with `
keycode_switch_to_browser`.

## Installation
1. Clone the repository
2. Install AutoHotkey v2
3. [Install AutoHotInterception by evilC](https://github.com/evilC/AutoHotInterception?tab=readme-ov-file#setup) by installing [Interception](https://github.com/oblitum/Interception/releases) and using the cloned directory as your 'working folder'
4. Run `Monitor.ahk` to determine the IDs of your keyboards. Set these as `keyboardId1` and `keyboardId2` in `MultiUser.ahk`
5. Use the AutoHotKey Dash tool, `Window Spy`, to determine window executable names of the two browsers and two ides and set these to `ide1`, `ide2`, `browser1`, and `browser2`
6. Run `MultiUser.ahk`