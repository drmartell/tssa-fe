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
FileReadLine, shareSizes, .env, 3
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

row1Y := 0
row2Y := 26
ConstructGui:
    GuiCount++
    GuiName := "TSSA_Trader" . GuiCount
    Gui, %GuiName%: new
    Gui, %GuiName%: Color, %colorGreen%
    
    Gui, %GuiName%: Add, ComboBox, vRisk%GuiName% x0 y%row1Y% w42, %riskAmounts%
    Gui, %GuiName%: Add, Edit, Uppercase vTicker%GuiName% x43 y%row1Y% w40 h21, TICKER
    Gui, %GuiName%: Add, Button, gSubscribe Hidden Default, Subscribe
    Gui, %GuiName%: Add, Radio, gBkgGreen vSide%GuiName% x85 y%row1Y% w24 h22 Checked, L
    Gui, %GuiName%: Add, Radio, gBkgRed x109 y%row1Y% w23 h23, S
    Gui, %GuiName%: Add, CheckBox, vPriorBar%GuiName% x134 y%row1Y% w31 h23, P
    Gui, %GuiName%: Add, Checkbox, vOSO%GuiName% x165 y%row1Y% w27 h23, B
    Gui, %GuiName%: Add, Button, gSend x189 y%row1Y% w30 h23, =>
    Gui, %GuiName%: Add, Button, gConstructGui x219 y%row1Y% w23 h23, +
    
    Gui, %GuiName%: Add, ComboBox, vShares%GuiName% x0 y%row2Y% w48, %shareSizes%
    Gui, %GuiName%: Add, Button, gQuantity_ x50 y%row2Y% w16 h23, _
    Gui, %GuiName%: Add, Button, gQuantity1 x66 y%row2Y% w16 h23, 1
    Gui, %GuiName%: Add, Button, gQuantity2 x82 y%row2Y% w16 h23, 2
    Gui, %GuiName%: Add, Button, gQuantity3 x98 y%row2Y% w16 h23, 3
    Gui, %GuiName%: Add, Button, gQuantity4 x114 y%row2Y% w16 h23, 4
    Gui, %GuiName%: Add, Button, gQuantity5 x130 y%row2Y% w16 h23, 5
    Gui, %GuiName%: Add, Button, gQuantity6 x146 y%row2Y% w16 h23, 6
    Gui, %GuiName%: Add, Button, gQuantity7 x162 y%row2Y% w16 h23, 7
    Gui, %GuiName%: Add, Button, gQuantity8 x178 y%row2Y% w16 h23, 8
    Gui, %GuiName%: Add, Button, gQuantity9 x194 y%row2Y% w16 h23, 9
    Gui, %GuiName%: Add, Button, gQuantity0 x210 y%row2Y% w16 h23, 0
    
    Gui, %GuiName%: +ToolWindow +AlwaysOnTop +Owner
    Gui, %GuiName%: Show, w242 h50, %GuiName%
    ControlFocus, TICKER, %GuiName%
    return

Quantity_:
    ControlSetText, Edit3,,
    return
Quantity1:
    ControlGetText, currentQuant, Edit3
    ControlSetText, Edit3, % currentQuant . 1
    return
Quantity2:
    ControlGetText, currentQuant, Edit3
    ControlSetText, Edit3, % currentQuant . 2
    return
Quantity3:
    ControlGetText, currentQuant, Edit3
    ControlSetText, Edit3, % currentQuant . 3
    return
Quantity4:
    ControlGetText, currentQuant, Edit3
    ControlSetText, Edit3, % currentQuant . 4
    return
Quantity5:
    ControlGetText, currentQuant, Edit3
    ControlSetText, Edit3, % currentQuant . 5
    return
Quantity6:
    ControlGetText, currentQuant, Edit3
    ControlSetText, Edit3, % currentQuant . 6
    return
Quantity7:
    ControlGetText, currentQuant, Edit3
    ControlSetText, Edit3, % currentQuant . 7
    return
Quantity8:
    ControlGetText, currentQuant, Edit3
    ControlSetText, Edit3, % currentQuant . 8
    return
Quantity9:
    ControlGetText, currentQuant, Edit3
    ControlSetText, Edit3, % currentQuant . 9
    return
Quantity0:
    ControlGetText, currentQuant, Edit3
    ControlSetText, Edit3, % currentQuant . 0
    return
    
CloseMessage:
    global MsgCount
    WinGetTitle, thisMsg, A
    Gui, %thisMsg%: Destroy
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
    osoString%thisName% := OSO%thisName% = 1 ? "TRUE" : "FALSE"
    orderUrl := serverUrl . "order"
    body := ({"ticker":Ticker%thisName%, "side":sideString%thisName%, "risk":Risk%thisName%, "priorbar":priorBarString%thisName%, "oso":osoString%thisName%})
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