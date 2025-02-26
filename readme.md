# MultiUser
A tool to allow multiple keyboards to allow two programmers to develop simultaneously on the same computer.

Each developer uses a separate keyboard, ide, and optionally browser.

Switch to your browser by pressing `Ctrl + Shift + "` (the `'`/`"` key) by default - configure with `
keycode_switch_to_browser`.

Reseve exclusive typing for `RESERVE_LENGTH` (default: 3 seconds) with `Ctrl + Shift + ;` (the `:`/`;` key) by default - configure with `
keycode_reserve_keyboard`.

## Installation
1. Clone the repository
2. Install AutoHotkey v2
3. [Install AutoHotInterception by evilC](https://github.com/evilC/AutoHotInterception?tab=readme-ov-file#setup) by installing [Interception](https://github.com/oblitum/Interception/releases) and using the cloned directory as your 'working folder'
4. Run `Monitor.ahk` to determine the IDs of your keyboards. Set these as `keyboardId1` and `keyboardId2` in `MultiUser.ahk`
5. Use the AutoHotKey Dash tool, `Window Spy`, to determine window executable names of the two browsers and two ides and set these to `ide1n`, `ide2n`, `browser1`, and `browser2`
6. Run `MultiUser.ahk`

## IDE 3 [OPTIONAL]
IDE3 allows a third user to use the second keyboard (`keyboardId2`)'s numpad and some media keys to control a third IDE, although meagerly.

Enable/Disable IDE3 with `ide3_enabled`

The main input scheme for IDE3 relies on two reigsters (`ABC` alphabet / `SYM` symbols) which are moved left and right and then selected to enter a character.

See comments in MultiUser.ahk for a more detailed view of the numpad controls, and to edit direct key mappings (use Scan Codes from `Monitor.ahk`)

Full IDE3 functionality requires the use of some media keys or adjacent keys which may be above the numpad keys.
You must remap the correct keys to Virtual Key 136-139. Currently, only the button above the NumSlash is in use for IDE3's shift, which must be remapped to VK137.

Configure ide3n to the third open ide.