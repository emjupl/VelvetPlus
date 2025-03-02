CoordMode, Pixel, Screen
CoordMode, Mouse, Screen

Gui, +ToolWindow +Border -Caption
Gui, Color, 0C0C0C

Gui, Font, s11 c0060ff, Dubai Bold
Gui, Add, Text, x10 y10 w310 h20, BLOCKHIT

Gui, Font, s10 cWhite, Dubai
Gui, Add, Text, x10 y40 w100 h20, Hold time (ms):
Gui, Font, s8 cBlack, Dubai
Gui, Add, Edit, vuserSleep1 x120 y40 w70 h20, 100

Gui, Font, s10 cWhite, Dubai
Gui, Add, Text, x10 y70 w100 h20, Delay (ms):
Gui, Font, s8 cBlack, Dubai
Gui, Add, Edit, vuserSleep2 x120 y70 w70 h20, 50

Gui, Font, s10 cWhite, Dubai
Gui, Add, Text, x10 y100 w100 h20, Trigger Color:
Gui, Font, s8 cBlack, Dubai
Gui, Add, Edit, vuserColor x120 y100 w70 h20, 3a3aab

Gui, Add, Button, vStartButton gSaveSettings x10 y130 w180 h20, Confirm

Gui, Font, cWhite s8
Gui, Add, Text, x10 y150 w180 h20 vDebugText, Active window: None

Gui, Show, x310 y310 w200 h170, Velvet Blockhit
WinSet, Transparent, 230, Velvet Blockhit

SetTimer, CheckColor, 10  ; Sprawdzaj kolor co 10 ms
Return

SaveSettings:
    Gui, Submit, NoHide
    configColor := "0x" userColor  ; Konwersja na poprawny format koloru
    sleepTime1 := userSleep1
    sleepTime2 := userSleep2
Return

CheckColor:
    CoordMode, Pixel, Screen
    CoordMode, Mouse, Screen
    ScreenWidth := A_ScreenWidth
    ScreenHeight := A_ScreenHeight
    MidX := ScreenWidth // 2
    MidY := ScreenHeight // 2

    PixelGetColor, color, %MidX%, %MidY%, RGB
    color := "0x" SubStr(color, 3)

    if (color = configColor) {
        if GetKeyState("W", "P") {
            Click, right down
            Sleep, %sleepTime1%
            Click, right up
            Sleep, %sleepTime2%
        }
    }
Return
