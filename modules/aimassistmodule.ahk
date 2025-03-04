; ############################## CHANGELOG V2.1 ##############################
; [ + ] Improved code speed with appropriate attributes to ensure optimization
; [ + ] In connection with the significant optimization of the code, added the ability to adjust the delay after the correct correction of the cursor
; [ + ] Added tolerance for the color to be detected
; ############################## CHANGELOG V2.1 ##############################

#Include, %A_ScriptDir%\lib\hex.ahk
#Persistent
#MaxThreadsPerHotkey 2
SetBatchLines -1
SetTitleMatchMode, 2

hexValues := Object("0", 0, "1", 1, "2", 2, "3", 3, "4", 4, "5", 5, "6", 6, "7", 7, "8", 8, "9", 9, "A", 10, "B", 11, "C", 12, "D", 13, "E", 14, "F", 15, "a", 10, "b", 11, "c", 12, "d", 13, "e", 14, "f", 15)

; stolen flags hehe
#InstallMouseHook
SetMouseDelay, -1
SetDefaultMouseSpeed, 0
SetWinDelay, -1
Process, Priority,, High
#NoEnv
#SingleInstance, Force
#UseHook
#KeyHistory, 0
#HotKeyInterval 1
#MaxHotkeysPerInterval 127
SetKeyDelay, -1, -1
SetControlDelay, -1
SendMode, InputThenPlay
ListLines, Off
CoordMode, Pixel, screen
PID := DllCall("GetCurrentProcessId")
Process, Priority, %PID%, High
DllCall("QueryPerformanceFrequency", "Int64*", Update)

global clientWindowTitle := "Client" ; Okno, w którym ma działać skrypt
hexValues := Object("0", 0, "1", 1, "2", 2, "3", 3, "4", 4, "5", 5, "6", 6, "7", 7, "8", 8, "9", 9, "A", 10, "B", 11, "C", 12, "D", 13, "E", 14, "F", 15, "a", 10, "b", 11, "c", 12, "d", 13, "e", 14, "f", 15)
windowHeight := 230
debugTextYLoc := windowHeight - 20
saveButtonYLoc := windowHeight - 40

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
Gui, Add, Edit, vTriggerColorEdit x120 y100 w70 h20, ff0000

Gui, Font, s10 cWhite, Dubai
Gui, Add, Text, x10 y130 w100 h20, Color Tolerance:
Gui, Font, s8 cBlack, Dubai
Gui, Add, Edit, vColorToleranceEdit x120 y130 w70 h20, 20

Gui, Font, s10 cWhite, Dubai
Gui, Add, Text, x10 y160 w100 h20, Delay after aiming (ms):
Gui, Font, s8 cBlack, Dubai
Gui, Add, Edit, vDelayAfterHitEdit x120 y160 w70 h20, 20

Gui, Add, Button, vStartButton gStartScript x10 y%saveButtonYLoc% w180 h20, Confirm

Gui, Font, cWhite s8
Gui, Add, Text, x10 y%debugTextYLoc% w180 h20 vDebugText, Active window: None

Gui, Show, x100 y310 w200 h%windowHeight%, Velvet Aimassist
WinSet, Transparent, 230, Velvet Aimassist
Return


; ############################## AIMASSIST V2.1 ##############################
StartScript:
    Gui, Submit, NoHide
    GuiControl, Disable, StartButton
	
    smoothness := SmoothnessEdit
    fov := FovEdit

    triggerColorHEX := "0x" . TriggerColorEdit
	triggerColorRGB := HexToRGB(triggerColorHEX ,hexValues)

    howMuchPixelsToSkip := 20
    maxMoveRange := fov + 20

	colorTolerance := ColorToleranceEdit
	delayAfterHit := DelayAfterHitEdit

    Loop {
	
		MouseGetPos, centerX, centerY
		PixelGetColor, checkedStopPixelColorMiddleHEX, % centerX, % centerY, RGB
		checkedStopPixelColorMiddleRGB := HexToRGB(checkedStopPixelColorMiddleHEX, hexValues)

		GuiControl, , DebugText, % checkedStopPixelColorMiddleHEX

		if (AreRGBsSimiliar(checkedStopPixelColorMiddleRGB.r, checkedStopPixelColorMiddleRGB.g, checkedStopPixelColorMiddleRGB.b, triggerColorRGB.r, triggerColorRGB.g, triggerColorRGB.b, colorTolerance)){
			Sleep, 1
			GuiControl, , DebugText, Zatrzymuje celownik na przeciwniku

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
				PixelGetColor, checkedPixelColorHEX, % xLeft, % centerY, RGB
				checkedPixelColorRGB := HexToRGB(checkedPixelColorHEX, hexValues)

				if (AreRGBsSimiliar(checkedPixelColorRGB.r, checkedPixelColorRGB.g, checkedPixelColorRGB.b, triggerColorRGB.r, triggerColorRGB.g, triggerColorRGB.b, colorTolerance)) {
					foundLeft := true
					targetXLeft := xLeft
				}
			}
			if (!foundRight) {
				PixelGetColor, checkedPixelColorHEX, % xRight, % centerY, RGB
				checkedPixelColorRGB := HexToRGB(checkedPixelColorHEX, hexValues)
				
				if (AreRGBsSimiliar(checkedPixelColorRGB.r, checkedPixelColorRGB.g, checkedPixelColorRGB.b, triggerColorRGB.r, triggerColorRGB.g, triggerColorRGB.b, colorTolerance)) {
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

				PixelGetColor, checkedStopPixelColorMiddleHEX, % centerX, % centerY, RGB
				checkedStopPixelColorMiddleRGB := HexToRGB(checkedStopPixelColorMiddleHEX, hexValues)
				if (AreRGBsSimiliar(checkedStopPixelColorMiddleRGB.r, checkedStopPixelColorMiddleRGB.g, checkedStopPixelColorMiddleRGB.b, triggerColorRGB.r, triggerColorRGB.g, triggerColorRGB.b, colorTolerance)){
					Sleep, 1
					GuiControl, , DebugText, Zatrzymuje celownik na przeciwniku
					break
				}

				sleep delayAfterHit
			}
		}
		if (foundRight) {
			while (centerX < targetXRight) {
				centerX := Min(centerX + smoothness, targetXRight)
				MouseMove, centerX, centerY, 1

				PixelGetColor, checkedStopPixelColorMiddleHEX, % centerX, % centerY, RGB
				checkedStopPixelColorMiddleRGB := HexToRGB(checkedStopPixelColorMiddleHEX, hexValues)
				if (AreRGBsSimiliar(checkedStopPixelColorMiddleRGB.r, checkedStopPixelColorMiddleRGB.g, checkedStopPixelColorMiddleRGB.b, triggerColorRGB.r, triggerColorRGB.g, triggerColorRGB.b, colorTolerance)){
					Sleep, 1
					GuiControl, , DebugText, Zatrzymuje celownik na przeciwniku
					break
				}

				sleep delayAfterHit
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

