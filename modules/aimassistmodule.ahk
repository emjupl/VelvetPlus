#Persistent
#MaxThreadsPerHotkey 2
SetBatchLines -1
SetTitleMatchMode, 2

global clientWindowTitle := "Client" ; Okno, w którym ma działać skrypt

CoordMode, Pixel, Screen
CoordMode, Mouse, Screen

Gui, +ToolWindow +Border -Caption
Gui, Color, 0C0C0C

Gui, Font, s11 c0060ff, Dubai Bold
Gui, Add, Text, x10 y10 w100 h20, AIM ASSIST

Gui, Font, s10 cWhite, Dubai
Gui, Add, Text, x10 y40 w100 h20, Smoothness:
Gui, Font, s8 cBlack, Dubai
Gui, Add, Edit, vSmoothnessEdit x120 y40 w50 h20, 20

Gui, Font, s10 cWhite, Dubai
Gui, Add, Text, x10 y70 w100 h20, FOV:
Gui, Font, s8 cBlack, Dubai
Gui, Add, Edit, vFovEdit x120 y70 w50 h20, 150

Gui, Font, s10 cWhite, Dubai
Gui, Add, Text, x10 y100 w100 h20, Trigger Color:
Gui, Font, s8 cBlack, Dubai
Gui, Add, Edit, vTriggerColorEdit x120 y100 w70 h20, 3a3aab

Gui, Add, Button, vStartButton gStartScript x10 y130 w180 h20, Confirm

Gui, Font, cWhite s8
Gui, Add, Text, x10 y150 w180 h20 vDebugText, Active window: None

Gui, Show, x100 y310 w200 h170, Velvet Aimassist
WinSet, Transparent, 230, Velvet Aimassist
Return


; ############################## AIMASSIST V2 ##############################
StartScript:
    Gui, Submit, NoHide
    GuiControl, Disable, StartButton
	
	
    smoothness := SmoothnessEdit
    fov := FovEdit
    triggerColor := "0x" . TriggerColorEdit
    howMuchPixelsToSkip := 20
    maxMoveRange := fov + 20

    Loop {
	
		MouseGetPos, centerX, centerY
		PixelGetColor, checkedStopPixelColorMiddle, % centerX, % centerY, RGB
		if (checkedStopPixelColorMiddle = triggerColor) {
			Sleep, 1
			Continue
		}
		foundLeft := false
		foundRight := false
		targetXLeft := centerX
		targetXRight := centerX
		Loop, % fov // howMuchPixelsToSkip {
			xLeft := centerX - (A_Index * howMuchPixelsToSkip)
			xRight := centerX + (A_Index * howMuchPixelsToSkip)
			if (Abs(xLeft - centerX) > maxMoveRange){
				break
			}
			if (Abs(xRight - centerX) > maxMoveRange){
				break
			}
			
			if (!foundLeft) {
				PixelGetColor, checkedPixelColor, % xLeft, % centerY, RGB
				if (checkedPixelColor = triggerColor) {
					foundLeft := true
					targetXLeft := xLeft
				}
			}
			if (!foundRight) {
				PixelGetColor, checkedPixelColor, % xRight, % centerY, RGB
				if (checkedPixelColor = triggerColor) {
					foundRight := true
					targetXRight := xRight
				}
			}
			if (foundLeft && foundRight) {
				break
			}
		}
		if (foundLeft) {
			while (centerX > targetXLeft) {
				centerX := Max(centerX - smoothness, targetXLeft)
				MouseMove, centerX, centerY, 1
				PixelGetColor, checkedStopPixelColorMiddle, % centerX, % centerY, RGB
				if (checkedStopPixelColorMiddle = triggerColor) {
					break
				}
			}
		}
		if (foundRight) {
			while (centerX < targetXRight) {
				centerX := Min(centerX + smoothness, targetXRight)
				MouseMove, centerX, centerY, 1
				PixelGetColor, checkedStopPixelColorMiddle, % centerX, % centerY, RGB
				if (checkedStopPixelColorMiddle = triggerColor) {
					break
				}
			}
		}
	}

Return

~LButton::
    ; Odśwież tytuł aktywnego okna po kliknięciu
    UpdateActiveWindowTitle()

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

