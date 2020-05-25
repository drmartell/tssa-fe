#NoEnv
#Warn
#SingleInstance Force
SendMode Input
SetWorkingDir %A_ScriptDir%
SetBatchLines -1

FileReadLine, serverUrl, .env, 1
FileReadLine, riskAmounts, .env, 2
whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
GuiCount := 1
colorGreen = 7CFC00
colorRed = F08080

ConstructGui:
    GuiName := "TSSA_Trader" . GuiCount
    Gui, %GuiName%: new
    Gui, %GuiName%: Color, %colorGreen%
    Gui %GuiName%: Add, Edit, vTicker%GuiCount% x0 y0 w50 h23, TICKER
    Gui %GuiName%: Add, Radio, gBkgGreen vSide%GuiCount% x46 y32 w24 h22 Checked, L
    Gui %GuiName%: Add, Radio, gBkgRed x70 y31 w23 h23, S
    Gui %GuiName%: Add, Button, x56 y0 w49 h23, SEND
    Gui %GuiName%: Add, Button, gConstructGui x104 y0 w25 h23, +
    Gui %GuiName%: Add, ComboBox, vRisk%GuiCount% x0 y32 w42, %riskAmounts%
    Gui %GuiName%: Add, CheckBox, vPriorBar%GuiCount% x95 y32 w31 h23, P

    Gui, +ToolWindow +AlwaysOnTop +Owner
    Gui Show, NoActivate w128 h59, Send Order
    GuiCount++
    return

BkgGreen:
    Gui, Color, %colorGreen%
    return

BkgRed:
    Gui, Color, %colorRed%
    return

ButtonSEND:
    Gui, Submit, NoHide
    sideString%GuiCount% := Side%GuiCount% = 1 ? "LONG" : "SHORT"
    priorBarString%GuiCount% := PriorBar%GuiCount% = 1 ? "TRUE" : "FALSE"
    url := serverUrl . "?ticker=" . Ticker%GuiCount% . "&side=" . sideString%GuiCount% . "&risk=" . Risk%GuiCount% . "&priorbar=" . priorBarString%GuiCount%
    whr.Open("GET", url, true)
    whr.Send()
    whr.WaitForResponse()
    MsgBox % whr.ResponseText
    return

GuiEscape:
GuiClose:
    ObjRelease(whr)
    ExitApp