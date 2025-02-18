#SingleInstance force
Persistent
#include Lib\AutoHotInterception.ahk
; AHK v2
AHI := AutoHotInterception()
keyboardId1 := AHI.GetKeyboardId(0x048D, 0xC104)
keyboardId2 := AHI.GetKeyboardId(0x046D, 0xC338)
AHI.SubscribeKeyboard(keyboardId1, true, KeyEvent1)
AHI.SubscribeKeyboard(keyboardId2, true, KeyEvent2)
;AHI.SubscribeKey(keyboardId1,

queuek1 := []
queuek2 := []

ide1 := "webstorm64.exe"
ide2 := "Code.exe"

browser1 := "chrome.exe"
browser2 := "msedge.exe"

browser1Active := false
browser2Active := false

keycode_switch_to_browser := 40 ; "/' KEY

ctrl1 := 0 ; 29
shif1 := 0 ; 42
ctrl2 := 0
shif2 := 0

activation := 0

KeyEvent1(code, state) {
    global activation
    activation := activation + 1

    global ctrl1
    global shif1
    o := true
    if (code = 29) {
        tooltip("ctrl1: " ctrl1 ", state: " state )
        ctrl1 := state
        o := false
    }
    if (code = 42) {
        tooltip("shif1: " shif1 ", state: " state)
        shif1 := state
        o := false
    }

    if o {
    tooltip("Keyboard1 Key - Code: " code ", State: " state ", Key: " GetKeySC(code) ", ctrl: " ctrl1 ", shif: " shif1 ", browser1Active: " browser1Active ", activation: " activation)
    }
    global browser1Active
    if (code = keycode_switch_to_browser && ctrl1 = 1 && shif1 = 1 && state = 0) {
        if (browser1Active = true) {
            browser1Active := false
            WinActivate("ahk_exe" ide1)
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
    global ctrl2
    global shif2
    if (code = 29) {
        ctrl2 := state
    }
    if (code = 42) {
        shif2 := state
    }

    global browser2Active
    if (code = keycode_switch_to_browser && ctrl2 = 1 && shif2 = 1 && state = 0) {
        if (browser2Active = true) {
            browser2Active := false
            WinActivate("ahk_exe" ide2)
        } else {
            browser2Active := true
            WinActivate("ahk_exe" browser2)
        }
    }
    else {
        queuek2.push({code: code, state: state})
    }
    tooltip("Keyboard2 Key - Code: " code ", State: " state " sh " shif2 ", ctrl " ctrl2)

}
while (true) {
    ; Send every key in key1q if it is not empty
    if (queuek1.length > 0) {
       ; loop over the keys in the queue
       if (browser1Active = true) {
           WinActivate("ahk_exe" browser1)
       } else {
           WinActivate("ahk_exe" ide1)
       }
        for key1 in queuek1 {
            AHI.SendKeyEvent(keyboardId1, key1.code, key1.state)
        }
        queuek1 := []
    }
    Sleep(20)
    if (queuek2.length > 0) {
        ; loop over the keys in the queue
        if (browser2Active = true) {
            WinActivate("ahk_exe" browser2)
        } else {
            WinActivate("ahk_exe" ide2)
        }
        for key2 in queuek2 {
            AHI.SendKeyEvent(keyboardId2, key2.code, key2.state)
        }
        queuek2 := []
    }
    Sleep(20)

}