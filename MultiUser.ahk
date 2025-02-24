#SingleInstance force
Persistent
#include Lib\AutoHotInterception.ahk
; AHK v2
AHI := AutoHotInterception()

keyboardId1 := AHI.GetKeyboardId(0x048D, 0xC104) 
keyboardId2 := AHI.GetKeyboardId(0x046D, 0xC33F)
; keyboardId2 := AHI.GetKeyboardId(0x046D, 0xC338)

AHI.SubscribeKeyboard(keyboardId1, true, KeyEvent1)
AHI.SubscribeKeyboard(keyboardId2, true, KeyEvent2)
;AHI.SubscribeKey(keyboardId1,

queuek1 := []
queuek2 := []

ide1n := "WindowsTerminal.exe"
ide2n := "pycharm64.exe"
MsgBox("Getting IDE ID's, IDE's must be open, if closed please restart this script. Release all modifiers")
ide1 := WinGetID("ahk_exe" ide1n)
ide2 := WinGetID("ahk_exe" ide2n)


browser1 := "chrome.exe"
browser2 := "msedge.exe"

browser1Active := false
browser2Active := false

keycode_switch_to_browser := 40 ; "/' KEY

ctrl1 := 0 ; 29
shif1 := 0 ; 42
alt1 := 0
ctrl2 := 0
shif2 := 0
alt2 := 0

ide3_enabled := true ; uses the numpad of keyboard2 to type in another IDE
ide3n := "Notepad.exe"
ide3 := WinGetID("ahk_exe" ide3n)
ide3_sym_chrs := "abcdefghijklmnopqrstuvwxyz"
ide3_abc_chrs := '0123456789[]().:"#<>\/*+-%_&^?;,@$!~``'
ide3_abc_pos := 0  ;     
ide3_sym_pos := 0  ;     
shif3 := 0     ;     
ide3_map := Map()  ;     
ide3_map[74] := 14 ;  BKSP    (    ) (SHIF) (    ) (    ) {MEDIA KEYS -- REMAP TO VK 136-139}
ide3_map[79] := 331 ; Left    [ABCL] [ABCN] [ABCR] [BKSP] {NUMPAD CONTROLS}         
ide3_map[76] := 328 ; Up      [SYML] [SYMN] [SYMR] [ENTR]       
ide3_map[80] := 336 ; Down    [CTRC] [_UP_] [CTRV] |ENTR|         
ide3_map[81] := 333 ; Right   [LEFT] [DOWN] [RIGT] [NOTU] (NumEnter is not usable as it appears as regular enter)          
ide3_map[82] := 57  ; Space   [___SPACE___] [SUGG] |NOTU|          
queuek3 := []
ide3_clipboard := ""
IDE3_COPY := 75
IDE3_PASTE := 77
IDE3_ABC_L := 325
IDE3_ABC_N := 309
IDE3_ABC_R := 55
IDE3_SYM_L := 71
IDE3_SYM_N := 72
IDE3_SYM_R := 73
IDE3_SUGGEST := 83 ; May change this to be simply NUMDel [.] -> '.'

KeyEvent1(code, state) {
    global ctrl1
    global shif1
    global alt1
    o := true
    if (code = 29 || code = 285) { ; Note: uses most recent modifier press, so pressing both of a modifier will break things
        ctrl1 := state
    }
    if (code = 42 || code = 310) {
        shif1 := state
    }
    if (code = 56 || code = 312) {
        alt1 := state
    }

    if o {
    tooltip("Keyboard1 Key - Code: " code ", State: " state ", Key: " GetKeySC(code) ", ctrl: " ctrl1 ", shif: " shif1 ", browser1Active: " browser1Active)
    }
    global browser1Active
    if (code = keycode_switch_to_browser && ctrl1 = 1 && shif1 = 1 && state = 0) {
        if (browser1Active = true) {
            browser1Active := false
            WinActivate(ide1)
;            MsgBox("Switching to IDE 1 " activation)
        } else {
            browser1Active := true
            WinActivate("ahk_exe" browser1)
;            MsgBox("Switching to Browser 1 " activation)
        }
    }
    else {
        queuek1.push({code: code, state: state})
    }

;     stdout.WriteLine("queuek1: " queuek1)
}

KeyEvent2(code, state) {
;    SendInput GetKeyName(code)
    o := true
    global ctrl2
    global shif2
    global alt2
    if (code = 29 || code = 285) {
        ctrl2 := state
    }
    if (code = 42 || code = 310) {
        shif2 := state
    }
    if (code = 56 || code = 312) {
        alt2 := state
    }

    was_i3_key := false
    if (ide3_enabled){
        global ide3_abc_pos
        global ide3_sym_pos
        ; Registers
        if code = IDE3_ABC_L && state = 1 { ; leftABC
            ide3_abc_pos := ide3_abc_pos - 1
            if ide3_abc_pos < 0 {
                ide3_abc_pos := ide3_abc_pos + ide3_sym_chrs.length
            }
            was_i3_key := true
        }
        else if code = IDE3_ABC_R && state = 1 { ; rightABC
            ide3_abc_pos := Mod(ide3_abc_pos + 1, ide3_abc_chrs.length)
            ToolTip("ABCR: " ide3_abc_chrs[ide3_abc_pos])  
            was_i3_key := true
        }
        else if code = IDE3_SYM_L && state = 1 { ; leftSYM
            ide3_sym_pos := ide3_sym_pos - 1
            if ide3_sym_pos < 0 {
                ide3_sym_pos := ide3_sym_pos + ide3_sym_chrs.length
            }
            was_i3_key := true
        }
        else if code = IDE3_SYM_R && state = 1 { ; rightSYM
            ide3_sym_pos := Mod(ide3_sym_pos + 1, ide3_sym_chrs.length)  
            was_i3_key := true
        }
        else if code = IDE3_ABC_N && state = 1 {
            queuek3.Push({code: GetKeySC(SubStr(ide3_abc_chrs, ide3_abc_pos, 1)), state: 1})
            queuek3.Push({code: GetKeySC(SubStr(ide3_abc_chrs, ide3_abc_pos, 1)), state: 0})
            was_i3_key := true
        }
        else if code = IDE3_SYM_N && state = 1 {
            queuek3.Push({code: GetKeySC(SubStr(ide3_sym_chrs, ide3_sym_pos, 1)), state: 1})
            queuek3.Push({code: GetKeySC(SubStr(ide3_sym_chrs, ide3_sym_pos, 1)), state: 0})
            was_i3_key := true
        }
        ;               
    }

    global browser2Active
    if (code = keycode_switch_to_browser && ctrl2 = 1 && shif2 = 1 && state = 0 && (!ide3_enabled || !was_i3_key)) {
        if (browser2Active = true) {
            browser2Active := false
            WinActivate(ide2)
        } else {
            browser2Active := true
            WinActivate("ahk_exe" browser2)
        }
    }
    else {
        queuek2.push({code: code, state: state})
    }
    if (o){
        tooltip("Keyboard2 Key - Code: " code ", State: " state " sh " shif2 ", ctrl " ctrl2)
    }

}
while (true) {
    ; Send every key in key1q if it is not empty
    if (queuek1.length > 0) {
       ; send appropriate modifiers
       AHI.SendKeyEvent(keyboardId1, 29, ctrl1)
       AHI.SendKeyEvent(keyboardId1, 42, shif1)
       AHI.SendKeyEvent(keyboardId1, 56, alt1)   
       ; loop over the keys in the queue
       if (browser1Active = true) {
           WinActivate("ahk_exe" browser1)
       } else {
           WinActivate(ide1)
       }
        for key1 in queuek1 {
            AHI.SendKeyEvent(keyboardId1, key1.code, key1.state)
        }
        queuek1 := []
    }
    Sleep(20)
    if (queuek2.length > 0) {
        AHI.SendKeyEvent(keyboardId2, 29, ctrl2)
        AHI.SendKeyEvent(keyboardId2, 42, shif2)
        AHI.SendKeyEvent(keyboardId2, 56, alt2)  
        ; loop over the keys in the queue
        if (browser2Active = true) {
            WinActivate("ahk_exe" browser2)
        } else {
            WinActivate(ide2)
        }
        for key2 in queuek2 {
             AHI.SendKeyEvent(keyboardId2, key2.code, key2.state)
        }
        queuek2 := []
    }
    Sleep(20)
    if (ide3_enabled && queuek3.Length > 0) {
        AHI.SendKeyEvent(keyboardId2, 42, shif3)
        WinActivate(ide3)
        for key3 in queuek3 {
            AHI.SendKeyEvent(keyboardId2, key3.code, key3.state)
        }
    }

}

; Use VK89 (137) (above Num/ media key) as shift 3
if (ide3_enabled){
vk89 up::
{
    global shif3
    shif3 := 0
    ToolTip("play_pause_up " GetKeyState("vk89", "P") " " A_TickCount)
}

vk89::
{
    shif3 := 1
    ToolTip("play_pause_down " GetKeyState("vk89", "P") " " A_TickCount)
}
}