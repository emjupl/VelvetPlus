Gui, Color, Black, Black
Gui, Font, cWhite s12
Gui, Add, Text, x10 y10, Velvet+
Gui, Font, cWhite s10

Gui, Add, Checkbox, x10 y40 vAutoClicker gToggleScript, Autoclicker
Gui, Add, Checkbox, x10 y70 vAimAssist gToggleScript, Aimassist
Gui, Add, Checkbox, x10 y100 vBlockHit gToggleScript, Block Hit

autoclicker := A_ScriptDir . "\modules\autoclickermodule.ahk"
aimassist := A_ScriptDir . "\modules\aimassistmodule.ahk"
blockhit := A_ScriptDir . "\modules\blockhitmodule.ahk"

Gui, Show, w200 h150, Velvet+
return

ToggleScript:
GuiControlGet, state,, %A_GuiControl%
if (state)
{
    if (A_GuiControl = "AutoClicker")
        Run, %autoclicker%
    else if (A_GuiControl = "AimAssist")
        Run, %aimassist%
    else if (A_GuiControl = "BlockHit")
        Run, %blockhit%
}
else
{
    if (A_GuiControl = "AutoClicker")
        CloseScript("autoclickermodule.ahk",TimeOut=2)
    else if (A_GuiControl = "AimAssist")
        CloseScript("aimassistmodule.ahk",TimeOut=2)
    else if (A_GuiControl = "BlockHit")
        CloseScript("blockhitmodule.ahk",TimeOut=2)
}
return

CloseScript(Name,TimeOut=2)
    {
    DetectHiddenWindows On
    SetTitleMatchMode RegEx
    IfWinExist, i)%Name%.* ahk_class AutoHotkey
        {
        WinClose
        WinWaitClose, i)%Name%.* ahk_class AutoHotkey, , % TimeOut
        If ErrorLevel
            return "Unable to close" . Name
        else
            return "Closed" . Name
        }
    else
        return Name . " not found"
    }

GuiClose:
CloseScript("autoclickermodule.ahk",TimeOut=2)
CloseScript("aimassistmodule.ahk",TimeOut=2)
CloseScript("blockhitmodule.ahk",TimeOut=2)
ExitApp
