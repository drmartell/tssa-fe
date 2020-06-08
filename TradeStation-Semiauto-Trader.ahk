#NoEnv
; #Warn
#SingleInstance Force
SendMode Input
SetWorkingDir %A_ScriptDir%
; #Include JSON.ahk
#Include JSON_FromObj.ahk
SetBatchLines -1
SetTitleMatchMode, 1

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

row1Y := 26
row2Y := 52
ConstructGui:
    GuiCount++
    GuiName := "TSSA_Trader" . GuiCount
    Gui, %GuiName%: new
    Gui, %GuiName%: Add, Tab3, vThisTabControl%GuiName% Buttons Left h70, SemiAuto|Manual
    Gui, %GuiName%: Color, %colorGreen%
    
    Gui, %GuiName%: Tab, SemiAuto
    Gui, %GuiName%: Add, ComboBox, vRisk%GuiName% x+0 y+0 w42, %riskAmounts%
    Gui, %GuiName%: Add, Edit, Uppercase vTicker%GuiName% x+1 w45 h21, TICKER
    Gui, %GuiName%: Add, Button, gSubscribe Hidden Default x+0 w0, Subscribe
    Gui, %GuiName%: Add, Radio, gBkgGreen vSide%GuiName% x+1 w24 h22 Checked, B
    Gui, %GuiName%: Add, Radio, gBkgRed x+1 w23 h23, S
    Gui, %GuiName%: Add, CheckBox, vPriorBar%GuiName% x+1 h23, P
    Gui, %GuiName%: Add, Checkbox, vOSO%GuiName% x+0 h23, Bk
    Gui, %GuiName%: Add, Button, gSendAuto x+1 w30 h23, =>
    Gui, %GuiName%: Add, Button, gConstructGui x+1 w23 h23, +
    
    ; Gui, %GuiName%: Tab, Manual
    Gui, %GuiName%: Add, ComboBox, vShares%GuiName% x60 y+0 w48, %shareSizes%
    Gui, %GuiName%: Add, Edit, vRiskManual%GuiName% x+1 w40,
    Gui, %GuiName%: Add, Button, gQuantity_ x+1 w16 h23, _
    Gui, %GuiName%: Add, Button, gQuantity1 x+1 w16 h23, 1
    Gui, %GuiName%: Add, Button, gQuantity2 x+1 w16 h23, 2
    Gui, %GuiName%: Add, Button, gQuantity3 x+1 w16 h23, 3
    Gui, %GuiName%: Add, Button, gQuantity4 x+1 w16 h23, 4
    Gui, %GuiName%: Add, Button, gQuantity5 x+1 w16 h23, 5
    Gui, %GuiName%: Add, Button, gQuantity6 x+1 w16 h23, 6
    Gui, %GuiName%: Add, Button, gQuantity7 x+1 w16 h23, 7
    Gui, %GuiName%: Add, Button, gQuantity8 x+1 w16 h23, 8
    Gui, %GuiName%: Add, Button, gQuantity9 x+1 w16 h23, 9
    Gui, %GuiName%: Add, Button, gQuantity0 x+1 w16 h23, 0
    ; 2nd row
    Gui, %GuiName%: Add, Button, gSend2Bid x60 y+1 w36 h23, <<Bid
    Gui, %GuiName%: Add, Button, gSend1Bid x+1 w30 h23, <Bid
    Gui, %GuiName%: Add, Button, gSendBid x+1 w30 h23, [Bid]
    Gui, %GuiName%: Add, Button, gSendBid1 x+1 w30 h23, Bid>
    Gui, %GuiName%: Add, Button, gSendSplit x+1 w30 h23, Split
    Gui, %GuiName%: Add, Button, gSend1Ask x+1 w30 h23, <Ask
    Gui, %GuiName%: Add, Button, gSendAsk x+1 w30 h23, [Ask]
    Gui, %GuiName%: Add, Button, gSendAsk1 x+1 w30 h23, Ask>
    Gui, %GuiName%: Add, Button, gSendAsk2 x+1 w36 h23, Ask>>
    
    Gui, %GuiName%: Add, StatusBar,, ...
    
    Gui, %GuiName%: +ToolWindow +AlwaysOnTop +Owner
    Gui, %GuiName%: Show, w370 h105, %GuiName%
    ControlFocus, TICKER, %GuiName%
    return

GuiSize:
    WinGetTitle, thisName, A
    Gui, %thisName%: Submit, NoHide
    GuiControl, Move, ThisTabControl%thisName% , x0 y0
    return
    
Quantity_:
    GuiControlGet, OutputVar , Focus,
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
    Gui, %thisName%:Default ; needed to set status bar text
    Gui, %thisName%: Submit, NoHide
    subscribeUrl := serverUrl . "subscribe"
    body := ({"ticker":Ticker%thisName%})
    whr.Open("POST", subscribeUrl, true)
    whr.SetRequestHeader("Content-Type", "application/json")
    whr.Send(JSON_FromObj(body))
    try {
        whr.WaitForResponse(5)
        ; ShowMsg(whr.ResponseText)
        SB_SetText(whr.ResponseText)
    }
    catch e {
        ShowMsg(e)
        whr.ResponseText := timeout
    }
    return

SendAuto:
    WinGetTitle, thisName, A
    Gui, %thisName%: Submit, NoHide
    sideString%thisName% := Side%thisName% = 1 ? "LONG" : "SHORT"
    priorBarString%thisName% := PriorBar%thisName% = 1 ? "TRUE" : "FALSE"
    osoString%thisName% := OSO%thisName% = 1 ? "TRUE" : "FALSE"
    orderUrl := serverUrl . "order"
    body := ({"ticker":Ticker%thisName%, "side":sideString%thisName%, "risk":Risk%thisName%, "priorbar":priorBarString%thisName%, "oso":osoString%thisName%, "shares":Shares%thisName%})
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

SendManualOrder(entryType) {
    global whr
    global serverUrl
    WinGetTitle, thisName, A
    Gui, %thisName%: Submit, NoHide
    sideString%thisName% := Side%thisName% = 1 ? "LONG" : "SHORT"
    osoString%thisName% := OSO%thisName% = 1 ? "TRUE" : "FALSE"
    orderUrl := serverUrl . "manual-order"
    body := ({"ticker":Ticker%thisName%, "side":sideString%thisName%, "risk_manual":RiskManual%thisName%, "oso":osoString%thisName%, "shares":Shares%thisName%, "entry_type":entryType})
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
}

Send2Bid:
    SendManualOrder("Send2Bid")
    return
Send1Bid:
    SendManualOrder("Send1Bid")
    return
SendBid:
    SendManualOrder("SendBid")
    return
SendBid1:
    SendManualOrder("SendBid1")
    return
SendSplit:
    SendManualOrder("SendSplit")
    return
Send1Ask:
    SendManualOrder("Send1Ask")
    return
SendAsk:
    SendManualOrder("SendAsk")
    return
SendAsk1:
    SendManualOrder("SendAsk1")
    return
SendAsk2:
    SendManualOrder("SendAsk2")
    return
    
#IfWinActive ahk_class AutoHotkeyGUI
~LButton:: ; capture Left mouse clicks while allowing pass through of default functionality
    gosub, GuiSize
    return
    
;#IfWinActive ahk_class AutoHotkeyGUI
;~LButton:: ; capture Left mouse clicks while allowing pass through of default functionality
;    WinGetTitle, thisName, A
;    Sleep, 50
;    GuiControlGet, ActiveControl, %thisName%:Focus ; retrieve the control that has focus from this specific window
;    if(ActiveControl = "Edit1")
;        MsgBox, ActiveControl . %ActiveControl%
;    return
    
    
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