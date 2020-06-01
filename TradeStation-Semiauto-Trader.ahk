#NoEnv
; #Warn
#SingleInstance Force
SendMode Input
SetWorkingDir %A_ScriptDir%
; #Include JSON.ahk
#Include JSON_FromObj.ahk
SetBatchLines -1

FileReadLine, serverUrl, .env, 1
FileReadLine, riskAmounts, .env, 2
whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
MsgCount := 0
GuiCount := 0
colorGreen = 7CFC00
colorRed = F08080

ShowMsg(theMessage) {
    global MsgCount
    MsgCount++
    MsgName := "TSSA_Msg" . MsgCount
    Gui, %MsgName%: Add, Text, , %theMessage%
    Gui, %MsgName%: Add, Button, gCloseMessage, OK
    Gui, %MsgName%: -SysMenu
    Gui, %MsgName%: Show, Center, %MsgName%
    return
}

ConstructGui:
    GuiCount++
    GuiName := "TSSA_Trader" . GuiCount
    Gui, %GuiName%: new
    Gui, %GuiName%: Color, %colorGreen%
    Gui, %GuiName%: Add, Edit, gMakeUpperCase vTicker%GuiName% x0 y0 w50 h23, TICKER
    Gui, %GuiName%: Add, Radio, gBkgGreen vSide%GuiName% x46 y32 w24 h22 Checked, L
    Gui, %GuiName%: Add, Radio, gBkgRed x70 y31 w23 h23, S
    Gui, %GuiName%: Add, Button, gSend x56 y0 w49 h23, SEND
    Gui, %GuiName%: Add, Button, gConstructGui x104 y0 w25 h23, +
    Gui, %GuiName%: Add, ComboBox, vRisk%GuiName% x0 y32 w42, %riskAmounts%
    Gui, %GuiName%: Add, CheckBox, vPriorBar%GuiName% x95 y32 w31 h23, P
    Gui, %GuiName%: Add, Button, gSubscribe Hidden Default, Subscribe
    
    Gui, %GuiName%: +ToolWindow +AlwaysOnTop +Owner
    Gui, %GuiName%: Show, w128 h59, %GuiName%
    ControlFocus, TICKER, %GuiName%
    return

CloseMessage:
    global MsgCount
    WinGetTitle, thisMsg, A
    Gui, %thisMsg%: Destroy
    return
    
MakeUpperCase:
    Sleep, 1000
    GuiControlGet, %A_GuiControl%
    StringUpper, upperTicker, %A_GuiControl%
    If (upperTicker == %A_GuiControl%)
        return
    SendInput, ^a{DEL}%upperTicker%
    return

BkgGreen:
    WinGetTitle, thisName, A
    Gui, %thisName%: Color, %colorGreen%
    return

BkgRed:
    WinGetTitle, thisName, A
    Gui, %thisName%: Color, %colorRed%
    return

Subscribe:
    WinGetTitle, thisName, A
    Gui, %thisName%: Submit, NoHide
    subscribeUrl := serverUrl . "subscribe"
    body := ({"ticker":Ticker%thisName%})
    whr.Open("POST", subscribeUrl, true)
    whr.SetRequestHeader("Content-Type", "application/json")
    whr.Send(JSON_FromObj(body))
    try {
        whr.WaitForResponse(5)
        ShowMsg(whr.ResponseText)
    }
    catch e {
        ShowMsg(e)
        whr.ResponseText := timeout
    }
    return

Send:
    WinGetTitle, thisName, A
    Gui, %thisName%: Submit, NoHide
    sideString%thisName% := Side%thisName% = 1 ? "LONG" : "SHORT"
    priorBarString%thisName% := PriorBar%thisName% = 1 ? "TRUE" : "FALSE"
    orderUrl := serverUrl . "order"
    body := ({"ticker":Ticker%thisName%, "side":sideString%thisName%, "risk":Risk%thisName%, "priorbar":priorBarString%thisName%})
    whr.Open("POST", orderUrl, true)
    whr.SetRequestHeader("Content-Type", "application/json")
    whr.Send(JSON_FromObj(body))
    try {
        whr.WaitForResponse(5)
        ShowMsg(whr.ResponseText)
    }
    catch e {
        ShowMsg(e)
        whr.ResponseText := timeout
    }
    return

; use Escape to completely exit the app and dispose whr
TSSA_Trader1GuiEscape:
TSSA_Trader2GuiEscape:
TSSA_Trader3GuiEscape:
TSSA_Trader4GuiEscape:
TSSA_Trader5GuiEscape:
TSSA_Trader6GuiEscape:
TSSA_Trader7GuiEscape:
TSSA_Trader8GuiEscape:
TSSA_Trader9GuiEscape:
TSSA_Trader10GuiEscape:
TSSA_Trader11GuiEscape:
TSSA_Trader12GuiEscape:
TSSA_Trader13GuiEscape:
TSSA_Trader14GuiEscape:
TSSA_Trader15GuiEscape:
TSSA_Trader16GuiEscape:
TSSA_Trader17GuiEscape:
TSSA_Trader18GuiEscape:
TSSA_Trader19GuiEscape:
TSSA_Trader20GuiEscape:
    global whr
    ObjRelease(whr)
    ExitApp