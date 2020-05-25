#NoEnv
; #Warn
#SingleInstance Force
SendMode Input
SetWorkingDir %A_ScriptDir%
SetBatchLines -1

FileReadLine, serverUrl, .env, 1
FileReadLine, riskAmounts, .env, 2
whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
GuiCount := 0
colorGreen = 7CFC00
colorRed = F08080

ConstructGui:
    GuiCount++
    GuiName := "TSSA_Trader" . GuiCount
    Gui, %GuiName%: new
    Gui, %GuiName%: Color, %colorGreen%
    Gui, %GuiName%: Add, Edit, vTicker%GuiName% x0 y0 w50 h23, TICKER
    Gui, %GuiName%: Add, Radio, gBkgGreen vSide%GuiName% x46 y32 w24 h22 Checked, L
    Gui, %GuiName%: Add, Radio, gBkgRed x70 y31 w23 h23, S
    Gui, %GuiName%: Add, Button, gSEND x56 y0 w49 h23, SEND
    Gui, %GuiName%: Add, Button, gConstructGui x104 y0 w25 h23, +
    Gui, %GuiName%: Add, ComboBox, vRisk%GuiName% x0 y32 w42, %riskAmounts%
    Gui, %GuiName%: Add, CheckBox, vPriorBar%GuiName% x95 y32 w31 h23, P
    
    Gui, %GuiName%: +ToolWindow +AlwaysOnTop +Owner
    Gui, %GuiName%: Show, NoActivate w128 h59, %GuiName%
    return

BkgGreen:
    WinGetTitle, thisName, A
    Gui, %thisName%: Color, %colorGreen%
    return

BkgRed:
    WinGetTitle, thisName, A
    Gui, %thisName%: Color, %colorRed%
    return

SEND:
    WinGetTitle, thisName, A
    Gui, %thisName%: Submit, NoHide
    sideString%thisName% := Side%thisName% = 1 ? "LONG" : "SHORT"
    priorBarString%thisName% := PriorBar%thisName% = 1 ? "TRUE" : "FALSE"
    url := serverUrl . "?ticker=" . Ticker%thisName% . "&side=" . sideString%thisName% . "&risk=" . Risk%thisName% . "&priorbar=" . priorBarString%thisName%
    whr.Open("GET", url, true)
    whr.Send()
    whr.WaitForResponse()
    MsgBox % whr.ResponseText
    return

GuiEscape:
GuiClose:
    ObjRelease(whr)
    ExitApp