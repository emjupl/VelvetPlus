#Persistent 
#MaxThreadsPerHotkey 2
SetBatchLines -1
SetTitleMatchMode, 2
global minDelay := 30
global maxDelay := 70
global moveMode := false
global windowTitle := "Velvet Autoclicker"
global alwaysOnTop := true
global jitterMode := false
global jitterRange := 2  
global clientWindowTitle := "Client" ; Okno, w którym ma działać skrypt
save_icon := A_ScriptDir . "\icons\save_icon.ico"

Gui, +ToolWindow +Border -Caption
Gui, Color, 0C0C0C

; Przycisk
Gui, Add, Picture, gSaveSettings x330 y10 w20 h20 vSaveBtn, %save_icon%

; Autoclicker
Gui, Font, c0060ff s11, Dubai Bold
Gui, Add, Text, x10 y10, AUTO CLICKER

; Zakres Autoclickera
Gui, Font, cWhite s10, Dubai
Gui, Add, Text, x10 y40, Min delay (ms):  
Gui, Font, cWhite s8, Dubai
Gui, Add, Edit, vMinDelay w100 h20 x250 y40 cBlack, %minDelay%

Gui, Font, cWhite s10, Dubai
Gui, Add, Text, x10 y70, Max delay (ms):  
Gui, Font, cWhite s8, Dubai
Gui, Add, Edit, vMaxDelay w100 h20 x250 y70 cBlack, %maxDelay%

; Jitter checkbox
Gui, Font, cWhite s10, Dubai Bold
Gui, Add, Checkbox, vJitterMode gToggleJitterMode x10 y110, Cursor jitter (Jitterclick)
GuiControl, , JitterMode, % jitterMode  

; Zakres jittera 
Gui, Font, cWhite s10, Dubai
Gui, Add, Text, x10 y140, Jitter range (px):  
Gui, Add, Slider, vJitterRange gUpdateJitterRange x250 y140 w100 h110 Range1-200, % jitterRange

; Debugowanie
Gui, Font, cWhite s8
Gui, Add, Text, x10 y180 w320 h30 vDebugText, Active window: None

Gui, Show, x100 y100 w360 h200, %windowTitle%  
WinSet, Transparent, 230, %windowTitle%
return

; Auto Clicker
~^LButton::
    if (!IsInClientWindow())  
        return  ; Jeśli auto clicker jest wyłączony lub użytkownik nie jest w oknie "Client", nic się nie dzieje

    While GetKeyState("LButton", "P") && GetKeyState("Ctrl", "P")
    {
        if (jitterMode)  
        {
            MouseGetPos, mouseX, mouseY
            Random, jitterX, -jitterRange, jitterRange  
            Random, jitterY, -jitterRange, jitterRange  
            MouseMove, mouseX + jitterX, mouseY + jitterY, 0  
        }
        
        Click
        
        Random, delay, %minDelay%, %maxDelay%
        Sleep, delay
    }
return


ToggleJitterMode:
    jitterMode := !jitterMode
return

UpdateJitterRange:
    Gui, Submit, NoHide
return

; Zapisywanie ustawień
SaveSettings:
    Gui, Submit, NoHide
    if (minDelay < 1 || maxDelay < minDelay) {
        MsgBox, 48, Error, Invalid values! Min delay must be greater than 0, and max delay must be greater than min.
        return
    }
    MsgBox, 64, Success, Settings have been saved successfully!
return

; Sprawdzanie kliknięcia poza oknem
~LButton::
    ; Odśwież tytuł aktywnego okna po kliknięciu
    UpdateActiveWindowTitle()
return

; Funkcja sprawdzająca, czy użytkownik znajduje się w oknie zawierającym słowo "Client"
IsInClientWindow() {
    WinGetActiveTitle, activeTitle
    GuiControl, , DebugText, Active window: %activeTitle%
    return InStr(activeTitle, clientWindowTitle)  ; Sprawdza, czy aktywne okno zawiera słowo "Client"
}

; Funkcja aktualizująca tytuł aktywnego okna w debugowaniu
UpdateActiveWindowTitle() {
    WinGetActiveTitle, activeTitle
    GuiControl, , DebugText, Active window: %activeTitle%
}

GuiClose:
    ExitApp
return
